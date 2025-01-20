locals {
  env         = "development"
  region      = "ap-south-1"
  zone1       = "ap-south-1a"
  zone2       = "ap-south-1b"
  zones       = ["ap-south-1a", "ap-south-1b"]
  eks_name    = "perx-eks"
  eks_version = "1.30"
}
