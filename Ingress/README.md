# Installing helm cli
wget https://get.helm.sh/helm-v3.12.2-linux-amd64.tar.gz
tar zxf helm-v3.12.2-linux-amd64.tar.gz
cd linux-amd64/
sudo mv helm /usr/bin/
helm version

# add helm repository
helm repo add nginx-stable https://helm.nginx.com/stable
# update helm repository
helm repo update

# Install Nginx Ingress Controller
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace

# Check is ingress is created
kubectl --namespace ingress-nginx get services -o wide ingress-nginx-controller
