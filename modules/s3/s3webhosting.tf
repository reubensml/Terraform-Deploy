provider "aws" {
  region = "${var.region}"

}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_site}"
  #acl    = "public-read"
  policy = <<EOF
{
  "Id": "bucket_policy_site",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "bucket_policy_site_main",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.bucket_site}/*",
      "Principal": "*"
    }
  ]
}
EOF
website {
       index_document = "index.html"
       error_document = "404.html"
  tags {
  Name        = "Trinity"
  Client = "${var.client}"
}
  force_destroy = true
}
resource "aws_s3_bucket_object" "object" {
  bucket = "${var.bucket_site}"
  key    = "index.html"
  source = "/Users/reubensamuel/terraformtrinity/modules/s3/index.html"
  etag   = "${md5(file("path/to/file"))}"
}
resource "aws_s3_bucket_object" "object" {
  bucket = "${var.bucket_site}"
  key    = "404.html"
  source = "/Users/reubensamuel/terraformtrinity/modules/s3/404.html"
  etag   = "${md5(file("path/to/file"))}"
}
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.mykey.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

output "url" {
  value = "${aws_s3_bucket.static_site.bucket}.s3-website-${var.region}.amazonaws.com"
}
