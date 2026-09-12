provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "nalinkaheshan-dev"
      ManagedBy = "terraform"
    }
  }
}
