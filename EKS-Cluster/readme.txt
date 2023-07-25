Generate AWS CLI credentials
Run the below 3 commands on CLI

$ export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
$ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
$ export AWS_DEFAULT_REGION=us-east-1

Install eksctl cli tool:
https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html
https://github.com/eksctl-io/eksctl/releases/tag/v0.150.0

create a file named aws.pub in your home directory .ssh
This file should contain the public key of the pem file you use to login to aws ec2 instances.
You can find this inside a existing ec2 instance already created using the key.

once eksctl is installed, run the below command
eksctl create cluster -f cluster.yaml

Install Ingress Controller from the website instructions:
https://aws.amazon.com/premiumsupport/knowledge-center/eks-access-kubernetes-services/

Once completed, delete the eks cluster
eksctl delete cluster --region=us-east-1 --name=basic-cluster --force
