resource "aws_s3_bucket" "img_mgr_bucket" {
  bucket_prefix = "${var.namespace}-${var.environment}-imgmgr-"
  acl           = "private"
  force_destroy = true

  tags = {
    Namespace   = var.namespace
    Environment = var.environment
  }
}

resource "local_file" "bucketmap" {
    content  = <<-EOT
apiVersion: v1
data:
  bucketName: ${aws_s3_bucket.img_mgr_bucket.bucket}
kind: ConfigMap
metadata:
  name: bucket
EOT
    filename = "../imgmgr.k8s/overlays/${var.environment}/bucketmap.yaml"
}