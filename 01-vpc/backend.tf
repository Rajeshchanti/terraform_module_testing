terraform {
  backend "s3" {
    bucket         = "techy-remote-state"
    key            = "vpc"
    region         = "us-east-1"
    dynamodb_table = "techy-locking"
  }
}