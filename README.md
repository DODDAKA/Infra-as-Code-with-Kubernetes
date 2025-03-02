# Infra-as-Code-with-Kubernetes

## Overview
This project demonstrates the implementation of a cloud-native infrastructure on Microsoft Azure using Infrastructure as Code (IaC) with Terraform and Kubernetes (AKS). The infrastructure is designed to be secure, scalable, and highly available.

## Key Components
- **Infrastructure as Code**: Terraform
- **Container Orchestration**: Azure Kubernetes Service (AKS)
- **Networking**: VNETS, SNETS, Route Tables, Hub and Spoke Architecture, Private Endpoints, Private DNS Zones, NAT Gateway, Express Route, Azure Bastion
- **Load Balancing**: Azure Front Door, Application Gateway, Standard Load Balancer
- **Security**: Azure Key Vault(RBAC and Vault Access Policy), Network Security Groups (NSGs), RBAC, Azure Firewall(Basic)
- **Data Services**: Azure PostgreSQL, Redis Cache, Storage Accounts(File Share, Blob Storage)
- **Compute**: Azure Virtual Machines
- **CI/CD**: Jenkins, Kubernetes Manifests
- **Container Registry**: Azure Container Registry
- **Monitoring**: Azure Monitor, Log Analytical Workspace, DCR, Azure Monitor Workspace, Azure Managed Prometheus& Grafana, Alerts Configuration
- **Redundancy&HA**: Recovery Service Vault, ASR Replication, Backup, Auto Scaling, Redundancy(LRS, ZRS, GRS, RA-GRS), DR Setup

## How to Run
1. Clone the repository.
2. Initialize and apply Terraform scripts.
3. Deploy applications to AKS.
4. Configure Jenkins for CI/CD.

## Architecture
![Final_PRJ_Visio](https://github.com/user-attachments/assets/9ea2b9b3-3bb8-4a8d-8836-852ef6441047)

## Sample screenshots for evidence
![Listerner_proof](https://github.com/user-attachments/assets/6e15718d-c9a5-4d26-ab3a-929c98bb573a)
![Listenr2_proff](https://github.com/user-attachments/assets/efe3038a-5a3e-4193-abc7-d1661af8c29f)
![Backend_healh](https://github.com/user-attachments/assets/7e4cdc77-2822-4dc6-80c5-b194e0749c27)
![web_proof](https://github.com/user-attachments/assets/dc500ce1-9f10-4333-acb4-8a9da558415a)



