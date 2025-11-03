variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_id" {
  description = "VPC ID where RDS will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "db_instance_type" {
  description = "Oracle RDS instance type"
  type        = string
  default     = "db.t3.medium"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment (e.g. dev, test, stage, prod)"
  type        = string
  default     = "dev"
}

