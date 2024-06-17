# AKS Client-Server Setup

This repository contains Terraform configurations to set up an Azure Kubernetes Service (AKS) cluster and deploy client and server applications using Docker images hosted on Docker Hub.

## Prerequisites

- Terraform installed
- Azure CLI installed
- Docker images for client and server pushed to Docker Hub
- Service Principal with necessary permissions to manage resources in your Azure subscription

## Setup

1. Clone this repository.
2. Configure your Terraform variables in `terraform.tfvars` file.
3. Initialize Terraform: use runner.sh
