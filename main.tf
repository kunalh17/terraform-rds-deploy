terraform {
  backend "s3" {
    bucket = "terraform-github-ec2-bucket"
    key    = "rds/oracle/terraform.tfstate"
    region = "ap-south-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "ap-south-1"
}

# ---------------------------
# SECURITY GROUP FOR ORACLE RDS
# ---------------------------
resource "aws_security_group" "oracle_rds_sg" {
  name        = "terraform-oracle-rds-sg"
  description = "Allow Oracle DB access"
  vpc_id      = "vpc-0c7beba8bb085aa58"

  ingress {
    description = "Allow Oracle access"
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ Allow all for demo only; restrict in prod
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Oracle-RDS-SG"
  }
}

# ---------------------------
# DB SUBNET GROUP
# ---------------------------
resource "aws_db_subnet_group" "oracle_rds_subnet_group" {
  name       = "terraform-oracle-rds-subnet-group"
  subnet_ids = ["subnet-0856410169a97e2f2"]

  tags = {
    Name = "Terraform-Oracle-RDS-Subnet-Group"
  }
}

# ---------------------------
# ORACLE RDS INSTANCE
# ---------------------------
resource "aws_db_instance" "oracle_rds" {
  identifier              = "terraform-oracle-db"
  engine                  = "oracle-se2"
  engine_version          = "19.0.0.0.ru-2024-07.rur-2024-07.r1"
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = "adminuser"
  password                = "AdminPass123!"
  db_subnet_group_name    = aws_db_subnet_group.oracle_rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.oracle_rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = true
  port                    = 1521

  tags = {
    Name = "Terraform-Oracle-RDS"
  }
}

# ---------------------------
# OUTPUTS
# ---------------------------
output "oracle_rds_endpoint" {
  value = aws_db_instance.oracle_rds.endpoint
}

output "oracle_rds_sg_id" {
  value = aws_security_group.oracle_rds_sg.id
}
