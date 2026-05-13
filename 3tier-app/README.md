# 3tier-app

A simplified 3-tier application scaffold for AWS EKS with Terraform, Kubernetes, and Docker.

## Structure

```
3tier-app/
├── terraform/
│   ├── main.tf
│   ├── vpc.tf
│   ├── eks.tf
│   ├── variables.tf
│   └── outputs.tf
├── k8s/
│   ├── frontend.yaml
│   ├── backend.yaml
│   └── ingress.yaml
├── docker/
│   ├── frontend/
│   │   └── Dockerfile
│   └── backend/
│       └── Dockerfile
└── README.md
```

## Quick start

1. Provision infrastructure with Terraform:

```bash
cd 3tier-app/terraform
terraform init
terraform apply -auto-approve
```

2. Build Docker images:

```bash
cd 3tier-app/docker/frontend
docker build -t 3tier-frontend .

cd ../backend
docker build -t 3tier-backend .
```

3. Deploy to Kubernetes:

```bash
kubectl apply -f ../k8s/backend.yaml
kubectl apply -f ../k8s/frontend.yaml
kubectl apply -f ../k8s/ingress.yaml
```

## Notes

- Adjust `terraform/variables.tf` for your AWS account and region.
- Update image names in `k8s/*.yaml` to match your container registry if needed.
