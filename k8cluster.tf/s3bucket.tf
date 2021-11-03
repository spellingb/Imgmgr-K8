resource "aws_s3_bucket" "img_mgr_bucket" {
  bucket_prefix = "${var.namespace}-${var.environment}-imgmgr-"
  acl           = "private"
  force_destroy = true

  tags = {
    Namespace   = var.namespace
    Environment = var.environment
  }
}
