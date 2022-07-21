terraform {
  backend "s3" {
    bucket = "varsha-tf-bucket"
    key = "main"
    region = "us-east-2"
  }
}
