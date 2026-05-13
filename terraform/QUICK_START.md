# Terraform Enterprise Deployment Guide

## Quick Start

### 1. Select Environment and Navigate

```bash
# For Development
cd terraform/environments/dev

# For Staging
cd terraform/environments/staging

# For Production
cd terraform/environments/prod
```

### 2. Initialize Terraform

```bash
# First time setup with backend configuration
terraform init

# Or with backend configuration from command line
terraform init -backend-config="bucket=company-terraform-state-dev" \
  -backend-config="key=3tier-app/dev/terraform.tfstate" \
  -backend-config="region=ap-south-1" \
  -backend-config="encrypt=true" \
  -backend-config="dynamodb_table=terraform-locks"
```

### 3. Plan Infrastructure Changes

```bash
terraform plan -out=tfplan
```

### 4. Apply Changes

```bash
terraform apply tfplan
```

### 5. Verify Deployment

```bash
# Get specific output
terraform output eks_cluster_endpoint

# Get all outputs
terraform output
```

## Environment-Specific Deployments

### Development Environment
```bash
cd environments/dev
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

### Staging Environment
```bash
cd environments/staging
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

### Production Environment
```bash
cd environments/prod
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## Managing Infrastructure

### View Resources

```bash
# List all resources in state
terraform state list

# Show specific resource details
terraform state show module.eks.aws_eks_cluster.main

# Show VPC module resources
terraform state list module.vpc
```

### Update Configuration

```bash
# Plan changes to specific module
terraform plan -target=module.eks

# Apply changes to specific module
terraform apply -target=module.eks
```

### Destroy Infrastructure

```bash
# Destroy all resources (use with caution)
terraform destroy

# Destroy resources in specific environment
cd environments/dev
terraform destroy -var-file=terraform.tfvars
```

## Database Secrets Management

The database password is automatically:
1. Generated using 32-character random strings with special characters
2. Stored in AWS Secrets Manager
3. Retrieved from Secrets Manager for the RDS password

**To retrieve the database password:**

```bash
# Get secret name from Terraform output
SECRET_NAME=$(terraform output -raw rds_secret_name)

# Retrieve password from AWS Secrets Manager
aws secretsmanager get-secret-value \
  --secret-id $SECRET_NAME \
  --region ap-south-1 \
  --query SecretString \
  --output text
```

## Monitoring and Logging

### CloudWatch Logs

- **EKS Control Plane**: `/aws/eks/{cluster-name}/cluster`
- **VPC Flow Logs**: `/aws/vpc/flowlogs/{project}-{environment}-vpc` (prod only)
- **RDS Database**: `/aws/rds/instance/{db-instance-id}/postgresql`

### CloudWatch Metrics

Access CloudWatch through AWS Console:
1. Navigate to CloudWatch > Metrics
2. Look for namespaces:
   - `AWS/EKS` - EKS cluster metrics
   - `AWS/RDS` - RDS database metrics
   - `AWS/EC2` - Node metrics

## Troubleshooting

### State Lock Issues

If Terraform is locked due to incomplete operations:

```bash
# List locks
terraform state list

# Force unlock (use with caution)
terraform force-unlock <LOCK_ID>
```

### Provider Issues

Update provider versions:

```bash
terraform init -upgrade
```

### Import Existing Resources

```bash
# Import an existing VPC
terraform import module.vpc.aws_vpc.main vpc-12345678

# Import an existing EKS cluster
terraform import module.eks.aws_eks_cluster.main cluster-name
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Terraform Deploy

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ap-south-1
      
      - name: Terraform Init
        run: |
          cd terraform/environments/dev
          terraform init
      
      - name: Terraform Plan
        run: |
          cd terraform/environments/dev
          terraform plan -var-file=terraform.tfvars -out=tfplan
      
      - name: Terraform Apply
        if: github.event_name == 'push'
        run: |
          cd terraform/environments/dev
          terraform apply tfplan
```

### GitLab CI Example

```yaml
stages:
  - plan
  - apply

variables:
  AWS_DEFAULT_REGION: ap-south-1

before_script:
  - cd terraform/environments/dev
  - terraform init

plan:
  stage: plan
  script:
    - terraform plan -var-file=terraform.tfvars -out=tfplan

apply:
  stage: apply
  script:
    - terraform apply -auto-approve tfplan
  only:
    - main
```

## Security Best Practices

### 1. Secrets Management
- Never commit `.tfvars` files with secrets
- Use AWS Secrets Manager for database passwords
- Use IAM roles instead of access keys when possible

### 2. State File Protection
```bash
# Ensure state encryption
aws s3api head-bucket --bucket company-terraform-state-dev
aws s3api get-bucket-versioning --bucket company-terraform-state-dev
aws s3api get-bucket-server-side-encryption-configuration --bucket company-terraform-state-dev
```

### 3. Access Control
```hcl
# Example: Restrict RDS access to VPC CIDR
ingress {
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}
```

### 4. Cost Management
- Review and update tags for cost allocation
- Use resource quotas in `locals.tf` for different environments
- Monitor AWS billing alerts

## Useful Commands

```bash
# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Plan with detailed output
terraform plan -var-file=terraform.tfvars > plan.txt

# Show resource attributes
terraform show -json | jq

# Remove resource from state (without destroying)
terraform state rm module.eks.aws_eks_cluster.main

# Move resource in state
terraform state mv module.old_name.resource module.new_name.resource
```

## Support and Documentation

- [Terraform Docs](https://www.terraform.io/docs)
- [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [EKS Best Practices](https://aws.amazon.com/eks/best-practices/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/best-practices)

## Team Guidelines

1. **Always plan before apply**: Use `terraform plan` and review changes
2. **Use terraform.lock.hcl**: Commit lock file for reproducible builds
3. **Code review**: Have at least one review before applying to production
4. **Backup state**: Regularly backup Terraform state files
5. **Document changes**: Update README when infrastructure changes
6. **Testing**: Use `terraform validate` and `terraform fmt` in CI/CD
