////////////////////////////////
// AWS Credentials

variable "aws_profile" {
  default = "default"
}

variable "region" {
  default = "us-east-1"
}

////////////////////////////////
// Global Settings

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "mondoo"
}

variable "default_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "Test"
  }
}

variable "mondoo_registration_token" {}


////////////////////////////////
// VPC Settings

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = true
}

////////////////////////////////
// EC2 Settings

variable "aws_key_pair_name" {}

variable "amazon2_instance_type" {
  default = "t2.micro"
}

variable "create_amazon2" {
  default = false
}

variable "ubuntu2204_instance_type" {
  default = "t2.micro"
}

variable "create_ubuntu2204" {
  default = false
}

variable "ubuntu2004_instance_type" {
  default = "t2.micro"
}

variable "create_ubuntu2004" {
  default = false
}

variable "ubuntu1804_instance_type" {
  default = "t2.micro"
}

variable "create_ubuntu1804" {
  default = false
}

variable "ubuntu1604_instance_type" {
  default = "t2.micro"
}

variable "create_ubuntu1604" {
  default = false
}

variable "rhel9_instance_type" {
  default = "t2.micro"
}

variable "create_rhel9" {
  default = false
}

variable "rhel8_instance_type" {
  default = "t2.micro"
}

variable "create_rhel8" {
  default = false
}

variable "debian10_instance_type" {
  default = "t2.micro"
}

variable "create_debian10" {
  default = false
}

variable "debian11_instance_type" {
  default = "t2.micro"
}

variable "create_debian11" {
  default = false
}

variable "suse15sp2_instance_type" {
  default = "t2.micro"
}

variable "create_suse15sp2" {
  default = false
}

variable "winserver2022_instance_type" {
  default = "t2.micro"
}

variable "create_windows2022" {
  default = false
}

variable "winserver2019_instance_type" {
  default = "t2.micro"
}

variable "create_windows2019" {
  default = false
}

variable "winserver2016_instance_type" {
  default = "t2.micro"
}

variable "create_windows2016" {
  default = false
}

variable "windows_admin_password" {
  default = "a9117eece836d0c9c6a18faad186976bf725fd5e"
}
