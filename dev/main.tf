module "Myroute53" {
  source       = "../modules/route53"
}

module "MyS3bucket" {
  source          = "../modules/s3"
}
