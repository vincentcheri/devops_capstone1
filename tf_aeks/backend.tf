terraform {
  backend "s3" {
    bucket       = "admingiwa-s3-sda"
    key          = "capstone1/eks/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}
