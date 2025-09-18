# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = merge(local.tags, {
    Name = "${var.project_name}-db-subnet-group"
  })
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS databases"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${var.project_name}-rds-sg"
  })
}

# MySQL for Catalog Service - COST OPTIMIZED
resource "aws_db_instance" "catalog_mysql" {
  identifier             = "${var.project_name}-catalog-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"      # Smallest instance
  allocated_storage      = 20                 # Minimum storage
  max_allocated_storage  = 0                  # Disable auto-scaling
  storage_encrypted      = false              # Disable encryption for cost
  storage_type           = "gp2"              # Use gp2 instead of gp3

  db_name  = "catalog"
  username = "admin"
  password = var.mysql_password

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  # Cost optimization settings
  skip_final_snapshot       = true
  deletion_protection       = false
  backup_retention_period   = 1              # Minimum backup retention
  backup_window             = "03:00-04:00"   # Short backup window
  maintenance_window        = "sun:04:00-sun:05:00"
  multi_az                  = false          # Single AZ deployment
  publicly_accessible       = false
  
  # Disable monitoring to save costs
  monitoring_interval = 0
  
  # Disable performance insights
  performance_insights_enabled = false

  tags = merge(local.tags, {
    Name = "${var.project_name}-catalog-mysql"
    Service = "catalog"
  })
}

# PostgreSQL for Orders Service - COST OPTIMIZED
resource "aws_db_instance" "orders_postgres" {
  identifier             = "${var.project_name}-orders-postgres"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"      # Smallest instance
  allocated_storage      = 20                 # Minimum storage
  max_allocated_storage  = 0                  # Disable auto-scaling
  storage_encrypted      = false              # Disable encryption for cost
  storage_type           = "gp2"              # Use gp2 instead of gp3

  db_name  = "orders"
  username = "admin"
  password = var.postgres_password

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  # Cost optimization settings
  skip_final_snapshot       = true
  deletion_protection       = false
  backup_retention_period   = 1              # Minimum backup retention
  backup_window             = "03:00-04:00"   # Short backup window
  maintenance_window        = "sun:04:00-sun:05:00"
  multi_az                  = false          # Single AZ deployment
  publicly_accessible       = false
  
  # Disable monitoring to save costs
  monitoring_interval = 0
  
  # Disable performance insights
  performance_insights_enabled = false

  tags = merge(local.tags, {
    Name = "${var.project_name}-orders-postgres"
    Service = "orders"
  })
}
