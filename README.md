# Infra-as-Code-with-Kubernetes

## Overview
This project demonstrates the implementation of a cloud-native infrastructure on Microsoft Azure using Infrastructure as Code (IaC) with Terraform and Kubernetes (AKS). The infrastructure is designed to be secure, scalable, and highly available.

## Key Components
- **Infrastructure as Code**: Terraform
- **Container Orchestration**: Azure Kubernetes Service (AKS)
- **Networking**: Azure Front Door, Application Gateway, Private Endpoints, Private DNS Zones, NAT Gateway, Express Route, VNETS, SNETS, Route Tables, Hub and Spoke Architecture
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

![AKS arch](https://github.com/user-attachments/assets/239d08ae-2212-4b29-9dde-4203a19cbc2b)
