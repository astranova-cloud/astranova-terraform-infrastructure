terraform {
  backend "s3" {
    bucket         = "astranova-terraform-state"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "astranova-terraform-locks"
    encrypt        = true
  }
}
