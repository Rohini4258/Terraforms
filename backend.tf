terraform {
  backend "s3" {
    bucket         = "newbucketforthstatefile1"
    key            = "day3/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-lock-dynamo"
    encrypt        = true
  }
}
