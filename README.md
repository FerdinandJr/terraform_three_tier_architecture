#Three Tier Terraform & AWS Infrastructure Setup

## Pre-Terraform Setup

### 1. Generate SSH Key Pair

This key will be used for EC2 instance access.
```bash
cd modules/key/
ssh-keygen -t rsa -b 4096 -f my-key
```

### Backend Configuration (S3 for Terraform State)

terraform {
  backend "s3" {
    bucket         = "your-s3-bucket-name"
    key            = "path/to/terraform.tfstate"
    region         = "your-aws-region"
    use_lockfile   = true
    encrypt        = true
  }
}


### Ensure that you have a valid SSL/TLS certificate available in AWS Certificate Manager (ACM):

Navigate to the AWS Console → Certificate Manager (ACM)

Create a new one using the domain name where your application will be hosted

### Confirm that your domain is properly configured in Amazon Route 53:

Go to AWS Console → Route 53 → Hosted Zones

Ensure there is a public hosted zone for your domain

### Terraform Apply
```bash
terraform init
terraform plan
terraform apply
```

### Database Setup and Secrets Manager

1. Store DB Credentials in AWS Secrets Manager
Create a secret in AWS Secrets Manager in JSON format:
```bash
{
  "username": "your-db-username",
  "password": "your-db-password"
}
```

Use Terraform to reference the secret:
```bash
data "aws_secretsmanager_secret" "rds" {
  name = "your-secrets-manager-name"
}
```

## Post-Terraform Setup

### Use the bastion host to connect securely to your private EC2 instances and RDS database.

Modify the config.sh script in the launch template repo, update the PHP connection config script and ensure the Auto Scaling Group (ASG) provisions instances with a valid RDS connection.

<?php 
$con = mysqli_connect('your-rds-endpoint', 'dbusername', 'dbpassword', 'my_store');
if ($con) {
  echo "Connected successfully!";
}
?>

### MySQL Database Initialization 

1. Create the Database. 
SSH into your EC2 instance (via bastion) and create the database:
```bash
mysql -h <your-rds-endpoint> -u <dbusername> -p -e "CREATE DATABASE IF NOT EXISTS my_store;"
```
2. Import SQL Schema 
Paste your SQL schema into a file:
```bash
nano my_store.sql
# Paste contents here and save
```
Import into MySQL:
```bash
mysql -h <your-rds-endpoint> -u <dbusername> -p my_store < my_store.sql
```