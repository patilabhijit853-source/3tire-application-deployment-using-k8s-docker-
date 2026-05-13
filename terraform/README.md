# Terraform Infrastructure as Code - 3-Tier Application Deployment

## Overview
This Terraform configuration manages the complete infrastructure for a 3-tier application deployment on AWS, including:
- VPC with public and private subnets across multiple availability zones
- EKS (Elastic Kubernetes Service) cluster for container orchestration
- RDS (Relational Database Service) for managed database
- IAM roles and policies for secure access control
- CloudWatch monitoring and logging

## Directory Structure

```
terraform/
├── main.tf                 # Root module configuration
├── variables.tf            # Input variables with validation
├── outputs.tf              # Output values
├── versions.tf             # Terraform and provider versions
├── locals.tf               # Computed local values and naming conventions
├── modules/                # Reusable modules
│   ├── vpc/               # VPC and networking module
│   ├── iam/               # IAM roles and policies
│   ├── eks/               # EKS cluster configuration
│   └── rds/               # RDS database configuration
└── environments/           # Environment-specific configurations
    ├── dev/               # Development environment
    ├── staging/           # Staging environment
    └── prod/              # Production environment
```

## Prerequisites

1. **AWS Account**: With appropriate credentials configured
2. **Terraform**: Version 1.0 or higher
   ```bash
   terraform version
   ```

3. **AWS CLI**: For credential management
   ```bash
   aws configure
   ```

4. **AWS Provider**: Version 5.0+

## Deployment Guide

### 1. Initialize Terraform

Choose your environment (dev, staging, or prod) and initialize:

```bash
cd environments/dev
terraform init
```

### 2. Review Configuration

View the planned changes:

```bash
terraform plan -out=tfplan
```

### 3. Apply Configuration

Deploy infrastructure:

```bash
terraform apply tfplan
```

### 4. Verify Deployment

Check outputs:

```bash
terraform output
```

## Environment Configuration

### Development Environment
- **Location**: `environments/dev/`
- **Cluster Size**: 1-2 nodes (t3.medium)
- **Database**: 20GB (t3.micro)
- **Backups**: Disabled
- **Multi-AZ**: No

### Staging Environment
- **Location**: `environments/staging/`
- **Cluster Size**: 2-4 nodes (t3.large)
- **Database**: 50GB (t3.small)
- **Backups**: 7 days retention
- **Multi-AZ**: Yes

### Production Environment
- **Location**: `environments/prod/`
- **Cluster Size**: 3-10 nodes (t3.xlarge)
- **Database**: 100GB (t3.small)
- **Backups**: 30 days retention
- **Multi-AZ**: Yes
- **Enhanced Monitoring**: Enabled

## Key Features

### Company Standards
- **Naming Convention**: `{project}-{environment}-{resource}`
- **Tagging Standard**: All resources tagged with Project, Environment, Company, CostCenter, ManagedBy, CreatedAt
- **Cost Center Tracking**: For billing and resource allocation

### Security
- Private subnets for databases and worker nodes
- NAT Gateway for outbound internet access
- IAM roles with least privilege principle
- RDS password stored in AWS Secrets Manager
- Encryption enabled by default (S3 backend, RDS)

### High Availability
- Multi-AZ deployment in staging/prod
- Auto-scaling for EKS nodes
- RDS failover support
- CloudWatch monitoring and logging

### State Management
- Remote S3 backend for team collaboration
- DynamoDB table for state locking
- Encryption enabled for sensitive data

## Important Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `environment` | Environment name (dev/staging/prod) | Required |
| `project_name` | Project identifier | `3tier-app` |
| `aws_region` | AWS region | `ap-south-1` |
| `company_name` | Company name for tagging | `YourCompany` |
| `cost_center` | Cost center for billing | Required |
| `enable_monitoring` | Enable CloudWatch monitoring | `true` |
| `log_retention_days` | CloudWatch log retention | `30` |

## Outputs

The following outputs are available after deployment:

- `eks_cluster_endpoint`: EKS cluster API endpoint
- `eks_cluster_name`: EKS cluster name
- `rds_endpoint`: RDS database endpoint
- `vpc_id`: VPC identifier
- `public_subnet_ids`: List of public subnet IDs
- `private_subnet_ids`: List of private subnet IDs

Access outputs:
```bash
terraform output <output_name>
```

## Management Commands

### Destroy Infrastructure
```bash
terraform destroy
```

### Update Infrastructure
```bash
terraform plan
terraform apply
```

### State Management
```bash
# List resources
terraform state list

# Show specific resource
terraform state show module.eks.aws_eks_cluster.main

# Remove resource from state
terraform state rm <resource_address>
```

## Best Practices

1. **State Files**: Never commit terraform state files to version control
2. **Secrets**: Use AWS Secrets Manager for sensitive data (passwords, tokens)
3. **Code Review**: Use `terraform plan` in pull requests for review
4. **Versioning**: Pin provider versions in versions.tf
5. **Naming**: Follow the naming convention: `{project}-{environment}-{resource}`
6. **Tags**: Always tag resources for cost tracking and management
7. **Backup**: Regularly backup Terraform state files
8. **Lock Files**: Commit terraform.lock.hcl to version control

## Troubleshooting

### State Lock Issues
If you encounter a locked state:
```bash
terraform force-unlock <LOCK_ID>
```

### Provider Issues
Update providers:
```bash
terraform init -upgrade
```

### Import Existing Resources
```bash
terraform import <resource_type>.<name> <aws_resource_id>
```

## CI/CD Integration

For GitLab CI/CD, GitHub Actions, or other CI systems:

```yaml
# Example GitHub Actions
- name: Terraform Plan
  run: terraform plan -out=tfplan

- name: Terraform Apply
  run: terraform apply tfplan
```

## Support and Documentation

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [EKS Best Practices Guide](https://aws.amazon.com/eks/best-practices/)

## Compliance and Auditing

- All infrastructure is managed by Terraform (no manual changes)
- All resources tagged for cost allocation
- CloudWatch Logs enabled for audit trails
- State files encrypted and locked

## Next Steps

1. Update `company_name` and `cost_center` variables
2. Configure S3 backend for state management
3. Set up CI/CD pipeline for automated deployments
4. Implement additional monitoring and alerting
5. Document environment-specific configurations
6. Plan disaster recovery and backup strategy
