terraform {
  backend "s3" {
  bucket = "techy-remote-state"
  key    = "sg"
  region = "us-east-1"
  dynamodynamodb_table = "techy-locking"  
  }
}