resource "random_id" "instance_id" {
  byte_length = 4
}

locals {
  linux_user_data = <<-EOT
    #!/bin/bash
    bash -c "$(curl -sSL https://install.mondoo.com/sh)"
    cnspec login --token ${var.mondoo_registration_token} --config /etc/opt/mondoo/mondoo.yml
    cnspec scan local --config /etc/opt/mondoo/mondoo.yml --asset-name $(uname -r)
  EOT

  windows_user_data = <<-EOT
    Set-ExecutionPolicy Unrestricted -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://install.mondoo.com/ps1'));
    Install-Mondoo;
    cnspec scan local --config /etc/opt/mondoo/mondoo.yml --asset-name $(Get-ComputerInfo | Select-Object OSName, OSVersion, OsHardwareAbstractionLayer)
  EOT

}

////////////////////////////////
// VPC Configuration

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1.0"

  name = "${var.prefix}-${random_id.instance_id.id}"
  cidr = var.vpc_cidr

  azs                = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets    = var.vpc_private_subnets
  public_subnets     = var.vpc_public_subnets
  enable_nat_gateway = var.vpc_enable_nat_gateway
}

////////////////////////////////
// Linux Security Groups

module "linux_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.3"

  name        = "${var.prefix}-${random_id.instance_id.id}-linux-sg"
  description = "Security group for linux instances"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "User-service ports (ipv4)"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}


////////////////////////////////
// Linux Instances

module "amazon2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.2"

  create                      = var.create_amazon2
  name                        = "${var.prefix}-amazon2"
  ami                         = data.aws_ami.amazon2.id
  instance_type               = var.amazon2_instance_type
  vpc_security_group_ids      = [module.linux_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = var.aws_key_pair_name
  associate_public_ip_address = true
  user_data                   = base64encode(local.linux_user_data)
  user_data_replace_on_change = true
}

module "rhel9" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.2"
  
  create                      = var.create_rhel9
  name                        = "${var.prefix}-rhel9"
  ami                         = data.aws_ami.rhel9.id
  instance_type               = var.rhel8_instance_type
  vpc_security_group_ids      = [module.linux_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = var.aws_key_pair_name
  associate_public_ip_address = true
  user_data                   = base64encode(local.linux_user_data)
  user_data_replace_on_change = true
}

module "ubuntu2204" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.2"

  create                      = var.create_ubuntu2204
  name                        = "${var.prefix}-ubuntu2204"
  ami                         = data.aws_ami.ubuntu2204.id
  instance_type               = var.ubuntu2204_instance_type
  vpc_security_group_ids      = [module.linux_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = var.aws_key_pair_name
  associate_public_ip_address = true
  user_data                   = base64encode(local.linux_user_data)
  user_data_replace_on_change = true
}

module "debian11" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.2"

  create                      = var.create_debian11
  name                        = "${var.prefix}-debian11"
  ami                         = data.aws_ami.debian11.id
  instance_type               = var.debian10_instance_type
  vpc_security_group_ids      = [module.linux_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = var.aws_key_pair_name
  associate_public_ip_address = true
  user_data                   = base64encode(local.linux_user_data)
  user_data_replace_on_change = true
}

module "suse15sp2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.2"

  create                      = var.create_suse15sp2
  name                        = "${var.prefix}-suse15sp2"
  ami                         = data.aws_ami.suse15sp2.id
  instance_type               = var.suse15sp2_instance_type
  vpc_security_group_ids      = [module.linux_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = var.aws_key_pair_name
  associate_public_ip_address = true
  user_data                   = base64encode(local.linux_user_data)
  user_data_replace_on_change = true
}

////////////////////////////////
// Windows Security Groups

module "windows_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.3"

  name        = "${var.prefix}-${random_id.instance_id.id}--windows-sg"
  description = "Security group for testing windows instances"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5985
      to_port     = 5986
      protocol    = "tcp"
      description = "Winrm ports"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      description = "Remote Desktop ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}


# ////////////////////////////////
# // Windows Instances

module "windows2022" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.2"

  create                      = var.create_windows2022
  name                        = "${var.prefix}-windows2022"
  ami                         = data.aws_ami.winserver2022.id
  instance_type               = var.winserver2022_instance_type
  vpc_security_group_ids      = [module.windows_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = var.aws_key_pair_name
  associate_public_ip_address = true
  user_data                   = base64encode(local.windows_user_data)
  user_data_replace_on_change = true
}

