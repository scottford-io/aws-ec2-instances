# AWS EC2 INSTANCES

This repository contains Terraform code for provisioning AWS EC2 instances for testing cnspec policies. The code creates the following:

- AWS VPC
- EC2 Security group for Linux with port 22 open to 0.0.0.0/0
- EC2 Security group for Windows with ports 3389, 5985-5986 open to 0.0.0.0/0
- EC2 instances into the provisioned VPC:
  - Amazon Linux 2
  - Ubuntu 2204, 2004, 1804, 1604
  - Debian 11, 10
  - Suse 15 SP2
  - Windows 2022, 2019, 2016

### Prereqs

- AWS Account
- Terraform
- Mondoo Platform account
- Mondoo Registration token

## Provision

Example `terraform.tfvars`:

```bash

prefix = "ec2-secops-test"

aws_key_pair_name = "scottford"

mondoo_registration_token = "eyJhbGciOiJFUzM4NCIsInR5cCI6IkpXVCJ9...."

create_amazon2 = true

create_windows2022 = true
```

```
terraform plan -out tfplan.out
terraform apply tfplan.out
```

