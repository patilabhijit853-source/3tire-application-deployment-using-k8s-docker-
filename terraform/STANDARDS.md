# Terraform Configuration Standards

## Naming Conventions

### Resource Naming Pattern
```
{project-name}-{environment}-{resource-type}
```

**Examples:**
- VPC: `3tier-app-dev-vpc`
- EKS Cluster: `3tier-app-dev-cluster`
- RDS Instance: `3tier-app-dev-db`
- Subnet: `3tier-app-dev-public-subnet-1`

### File Naming
- `main.tf` - Primary resource definitions
- `variables.tf` - Input variable declarations
- `outputs.tf` - Output value declarations
- `locals.tf` - Local computed values
- `data.tf` - Data sources
- `versions.tf` - Terraform and provider versions

## Code Organization

### Root Module Structure
```
terraform/
├── main.tf              # Root module configuration
├── variables.tf         # Root input variables
├── outputs.tf           # Root outputs
├── versions.tf          # Terraform version constraints
├── locals.tf            # Local computed values
├── modules/             # Reusable modules
└── environments/        # Environment-specific configs
```

### Module Structure
```
module/
├── main.tf              # Resource definitions
├── variables.tf         # Input variables
├── outputs.tf           # Outputs
├── data.tf              # Data sources
└── README.md            # Module documentation
```

## Tagging Standards

All resources must include company standard tags:

```hcl
tags = merge(
  var.tags,
  {
    Name        = "resource-name"
    Environment = var.environment
    Project     = var.project_name
    CostCenter  = var.cost_center
  }
)
```

**Required Tags:**
- `Project`: Project identifier
- `Environment`: dev, staging, or prod
- `Company`: Company name
- `CostCenter`: For billing and cost allocation
- `ManagedBy`: Always "Terraform"
- `CreatedAt`: Timestamp of creation

## Variable Validation

Always include validation for critical variables:

```hcl
variable "environment" {
  type        = string
  description = "Environment name"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

## Local Values Usage

Use locals for computed values and configuration:

```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Company     = var.company_name
  }
  
  # Environment-specific configuration
  env_config = {
    dev  = { ... }
    prod = { ... }
  }[var.environment]
}
```

## Module Best Practices

### 1. Always Use Descriptive Variables

```hcl
variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
  
  validation {
    condition     = can(regex("^t3\\.", var.instance_type))
    error_message = "Instance type must be t3 family."
  }
}
```

### 2. Provide Clear Outputs

```hcl
output "cluster_endpoint" {
  description = "EKS cluster API endpoint URL"
  value       = aws_eks_cluster.main.endpoint
  sensitive   = false
}
```

### 3. Use Depends_on for Dependencies

```hcl
resource "aws_eks_node_group" "main" {
  # ... configuration ...
  
  depends_on = [
    aws_iam_role_policy.eks_node_policy,
    aws_eks_cluster.main
  ]
}
```

## State Management

### Backend Configuration

Each environment should have its own backend:

```hcl
terraform {
  backend "s3" {
    bucket         = "company-terraform-state-{env}"
    key            = "3tier-app/{env}/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

### State Protection

- Enable S3 versioning
- Enable MFA delete
- Restrict IAM access
- Enable encryption
- Use DynamoDB for state locking

## Environment Parity

### Ensure Configuration Consistency

Use locals to maintain parity:

```hcl
locals {
  environment_config = {
    dev = {
      eks_node_desired_size = 1
      rds_allocated_storage = 20
      multi_az              = false
      backup_retention      = 0
    }
    prod = {
      eks_node_desired_size = 3
      rds_allocated_storage = 100
      multi_az              = true
      backup_retention      = 30
    }
  }
  
  env = local.environment_config[var.environment]
}
```

## Security Standards

### 1. Sensitive Variables

```hcl
variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password"
}

output "database_password" {
  value       = random_password.db.result
  sensitive   = true
}
```

### 2. Network Security

- Private subnets for databases and workers
- Security group rules with specific CIDR blocks
- No public access to RDS

### 3. Encryption

- Enable encryption for S3 backend
- Enable RDS encryption at rest
- Enable EBS encryption for EKS nodes

## Code Quality

### 1. Validation

```bash
terraform validate
```

### 2. Formatting

```bash
terraform fmt -recursive
```

### 3. Linting

Install and use tflint:

```bash
tflint --init
tflint
```

### 4. Documentation

Document all custom resources:

```hcl
# Generates a 32-character random password with special characters
# Stores it securely in AWS Secrets Manager
# Password is used for RDS database initialization
resource "random_password" "db_password" {
  length  = 32
  special = true
}
```

## Variable File Management

### Naming Convention

```
terraform.tfvars          # Default values
terraform.{env}.tfvars    # Environment-specific values
terraform.auto.tfvars     # Auto-loaded values
```

### Example Structure

**Dev Environment:**
```hcl
environment  = "dev"
project_name = "3tier-app"
aws_region   = "ap-south-1"
company_name = "YourCompany"
cost_center  = "ENGINEERING"
```

**Prod Environment:**
```hcl
environment  = "prod"
project_name = "3tier-app"
aws_region   = "ap-south-1"
company_name = "YourCompany"
cost_center  = "OPERATIONS"
enable_monitoring = true
```

## Error Handling

### Common Issues and Solutions

**Issue: State Lock**
```bash
terraform force-unlock <LOCK_ID>
```

**Issue: Provider Version Conflict**
```bash
terraform init -upgrade
```

**Issue: Resource Already Exists**
```bash
terraform import <resource_type>.<name> <aws_id>
```

## Monitoring and Observability

### CloudWatch Integration

All modules should export monitoring information:

```hcl
output "cluster_security_group_id" {
  description = "Security group for monitoring purposes"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}
```

### Logging

- Enable control plane logging for EKS
- Enable CloudWatch logs for RDS
- Enable VPC Flow Logs for networking visibility

## Team Workflow

### Git Workflow

1. Create feature branch: `feature/add-monitoring`
2. Make changes and validate: `terraform plan`
3. Create pull request with plan output
4. Review and approve changes
5. Merge and apply in CI/CD pipeline

### Code Review Checklist

- [ ] Variables have descriptions and validations
- [ ] Outputs have clear descriptions
- [ ] All resources are properly tagged
- [ ] Security groups follow least privilege
- [ ] Code follows naming conventions
- [ ] Plan output reviewed and approved
- [ ] No hardcoded values (use variables)
- [ ] Documentation updated

## References

- [Terraform Best Practices](https://www.terraform.io/docs/cloud/best-practices)
- [AWS Terraform Examples](https://github.com/aws-samples)
- [HashiCorp Certified Associate Study Guide](https://www.terraform.io/docs/cloud/users-teams-organizations/api-tokens)
