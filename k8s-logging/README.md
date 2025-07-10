eksctl create iamserviceaccount \
    --name ebs-csi-controller-sa \
    --namespace kube-system \
    --cluster valaxy-logging \
    --role-name AmazonEKS_EBS_CSI_DriverRole \
    --role-only \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
    --approve


ARN=$(aws iam get-role --role-name AmazonEKS_EBS_CSI_DriverRole --query 'Role.Arn' --output text)

eksctl create addon --cluster valaxy-logging --name aws-ebs-csi-driver --version latest --service-account-role-arn $ARN --force
```
kubectl create namespace logging

helm repo add elastic https://helm.elastic.co

helm install elasticsearch --set replicas=1 --set volumeClaimTemplate.storageClassName=gp2 --set persistence.labels.enabled=true elastic/elasticsearch -n logging
```

# for username
kubectl get secrets --namespace=logging elasticsearch-master-credentials -ojsonpath='{.data.username}' | base64 -d
# for password
kubectl get secrets --namespace=logging elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d

helm install kibana --set service.type=LoadBalancer elastic/kibana -n logging

helm repo add fluent https://fluent.github.io/helm-charts
helm install fluent-bit fluent/fluent-bit -f fluentbit-values.yaml -n logging
