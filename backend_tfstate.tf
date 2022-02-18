# Remote backend
terraform {
  backend "s3" {
    bucket         = "codepipeline-tfstate-backend"
    key            = "env:/dev/codepipeline.tfstate"
    region         = "us-east-1"
    dynamodb_table = "codepipeline-tf-locking"
    encrypt        = true
  }
}

# Creating bucket for tfstate
resource "aws_s3_bucket" "cp_bucket" {
  bucket = "codepipeline-tfstate-backend"
  tags = {
    Name = "S3 Remote tfstate"
  }
}

# Creating Dynamodf for locking
resource "aws_dynamodb_table" "tf_locking" {
  name           = "codepipeline-tf-locking"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB tfstate Lock Table"
  }
}
