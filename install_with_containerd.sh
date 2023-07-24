#Load Kernel modules at system startup
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

# These normally reflect post server restart
# To reflect them immediately withour restarting the server
sudo modprobe overlay
sudo modprobe br_netfilter

# Now set the kernel properties for the Kubernetes networking
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Now to Apply these properties without reboot the system
sudo sysctl --system
sudo systemctl restart systemd-modules-load.service

# Install Containerd
sudo apt-get update && sudo apt-get install -y containerd

# Create default configuration file for containerd:
sudo mkdir -p /etc/containerd

# Generate default containerd configuration and save to the newly created default file:
sudo containerd config default | sudo tee /etc/containerd/config.toml

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Restart containerd to ensure new configuration file usage:
sudo systemctl restart containerd

#--------------------------------------------
# Install Kubernetes

# Disable swap:
sudo swapoff -a

# Install dependency packages:
sudo apt-get update && sudo apt-get install -y apt-transport-https curl

#D ownload and add GPG key:
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Kubernetes to repository list:
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update package listings:
sudo apt-get update

# Install Kubernetes packages (Note: If you get a dpkg lock message, just wait a minute or two before trying the command again):
sudo apt-get install -y kubelet=1.26.7-00 kubeadm=1.26.7-00 kubectl=1.26.7-00

# Turn off automatic updates:
sudo apt-mark hold kubelet kubeadm kubectl

# Initialize the Cluster
# Initialize the Kubernetes cluster on the control plane node using kubeadm (Note: This is only performed on the Control Plane Node):
kubeadm init --pod-network-cidr 192.168.0.0/16

# Install the Calico Network Add-On
# On the control plane node, install Calico Networking:
# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
