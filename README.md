<<<<<<< HEAD
# Enterprise 3-Tier Application Deployment on AWS EKS

This project demonstrates a production-grade deployment of a 3-tier web application using a modern DevOps stack. It is designed to be scalable, secure, and fully automated, making it a perfect addition to a professional DevOps portfolio.

## 🚀 Live Demo
The application is currently deployed on AWS EKS. You can access it here:
[http://acb45b60598414df8bc35c24b1a20cd7-1408632945.ap-south-1.elb.amazonaws.com](http://acb45b60598414df8bc35c24b1a20cd7-1408632945.ap-south-1.elb.amazonaws.com)

---

## 🏗 Architecture Overview

The application consists of three distinct layers:
1. **Frontend**: A React.js application served via Nginx.
2. **Backend**: A Node.js Express API that handles business logic and database communication.
3. **Database**: A managed PostgreSQL instance on AWS RDS.

### Infrastructure Stack
- **Cloud Provider**: AWS (Region: `ap-south-1`)
- **Infrastructure as Code (IaC)**: Terraform (Modular architecture)
- **Containerization**: Docker (Multi-stage builds)
- **Orchestration**: Amazon EKS (Elastic Kubernetes Service)
- **Package Management**: Helm Charts
- **CI/CD**: GitHub Actions

---

## 📁 Project Structure

```text
.
├── .github/workflows/      # GitHub Actions CI/CD pipeline
├── terraform/               # Modular IaC for AWS
│   ├── modules/             # VPC, EKS, RDS, IAM modules
│   └── environments/       # Dev/Prod environment configurations
├── k8s/                      # Kubernetes orchestration
│   └── charts/3tier-app/     # Helm chart for the entire stack
├── src/                     # Application source code
│   ├── frontend/            # React app + Dockerfile
│   └── backend/             # Node.js API + Dockerfile
└── README.md                # Documentation
```

---

## 🚀 Deployment Guide

### 1. Prerequisites
- AWS Account with CLI configured.
- Terraform installed.
- `kubectl` and `helm` installed.
- GitHub repository with the following secrets configured:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

### 2. Provision Infrastructure
```bash
cd terraform/environments/dev
terraform init
terraform apply -auto-approve
```

### 3. Deploy Application
The deployment is fully automated via GitHub Actions. Simply push your code to the `main` branch. 

Alternatively, deploy manually using Helm:
```bash
aws eks update-kubeconfig --name abhi-infra-cluster --region ap-south-1
helm upgrade --install 3tier-app ./k8s/charts/3tier-app
```

---

## 🛡️ Security & Best Practices Implemented

- **Network Isolation**: Database and Backend reside in private subnets; only the Frontend Load Balancer is public.
- **Least Privilege**: IAM roles are strictly scoped for EKS and Node groups.
- **Image Optimization**: Multi-stage Docker builds reduce attack surface and image size.
- **Security Contexts**: Containers are configured to run as non-root users.
- **Health Monitoring**: Kubernetes Liveness and Readiness probes ensure high availability.

---

## 💰 Cost Estimation (ap-south-1)

Estimated cost for a **1-hour run**:

| Resource | Specification | Estimated Hourly Cost |
| :--- | :--- | :--- |
| EKS Cluster | Managed Control Plane | ~$0.10 |
| Worker Nodes | 2 x t3.medium | ~$0.14 |
| RDS Instance | db.t3.micro | ~$0.02 |
| NAT Gateway | Hourly charge | ~$0.05 |
| **Total** | | **~$0.31 / hour** |

---

## 🛠 Tech Stack Summary
`Terraform` $\rightarrow$ `AWS EKS` $\rightarrow$ `Docker` $\rightarrow$ `Helm` $\rightarrow$ `GitHub Actions` $\rightarrow$ `React/Node.js/Postgres`
=======
# 3tire-application-deployment-using-k8s-docker-
>>>>>>> 286baf84bdf15b6774aa3d41d1475d409440d4ec

### Screenshots 
<img width="1920" height="1080" alt="Screenshot (64)" src="https://github.com/user-attachments/assets/255bcc6a-b7ac-47e1-8b6a-46fc5e4be19a" />
<img width="1920" height="1080" alt="Screenshot (54)" src="https://github.com/user-attachments/assets/13e33126-a400-4196-83b8-be9b26fc6014" />
<img width="1920" height="1080" alt="Screenshot (55)" src="https://github.com/user-attachments/assets/34cda9a3-85ab-4972-80ed-50bb9f1aba24" />
<img width="1920" height="1080" alt="Screenshot (56)" src="https://github.com/user-attachments/assets/fb3f1c4a-46f3-434e-98d9-6c201eaa2e1a" />
<img width="1920" height="1080" alt="Screenshot (59)" src="https://github.com/user-attachments/assets/18a9463c-2d1b-4a60-9f57-166b2c292964" />

