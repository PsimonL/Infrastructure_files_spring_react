# Infrastructure_files_spring_react

## TERRAFORM Setup
Subfolder "terraform" contains Terraform configurations to set up an Azure Kubernetes Service (AKS) cluster and deploy client and server applications using Docker images hosted on Docker Hub.  
To run use:  
```
terraform init
terraform apply
```

## KUBERNETES Setup
Basic K8S template configs.
To run use
```
kubectl apply -f kubernetes/
```
