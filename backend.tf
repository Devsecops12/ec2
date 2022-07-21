terraform {
  backend "s3" {
    #This will allow you to download and view your state file.
    #acl     = "bucket-owner-full-control"
    #---------------------------
    # NEVER CHANGE THESE VALUES
    #---------------------------
    #This is the bucket where to store your state file.
    #bucket  = var.bucket_state_file
    #This ensures the state file is stored encrypted at rest in S3.
    encrypt = true
    #This is the region of your S3 Bucket.
    region  = "us-east-2"
    #---------------------------
    # Configurable Options
    #---------------------------
    #This will be the state file's file name.
    #key     = "s3/s3-templates"
    #This will be used as a folder in which to store your state file.
    workspace_key_prefix = "example-ec2"
  }
}
