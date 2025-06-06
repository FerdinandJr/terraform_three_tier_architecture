terraform {
  backend "s3" {
    bucket         = "my-terraform-state321"          # Name of the S3 bucket to store the state file
    key            = "envs/prod/terraform.tfstate"     # Path within the S3 bucket (state file location)
    region         = "ap-southeast-1"                  # AWS region where the S3 bucket and DynamoDB table are hosted
    use_lockfile   = true                              # ✅ Native S3-based state locking!
    encrypt        = true                              # Enable server-side encryption for the state file
  }
}