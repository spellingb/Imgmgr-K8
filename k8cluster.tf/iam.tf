resource "aws_iam_role" "cluster" {
  name_prefix = "${var.namespace}-${var.environment}-"

  assume_role_policy = data.aws_iam_policy_document.cluster-assume-role-policy.json
}
resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role" "node" {
  name_prefix = "eks-node-"

  assume_role_policy = data.aws_iam_policy_document.node-assume-role-policy.json

  inline_policy {
    name = "img_mgr_bucketpolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ]
          Effect   = "Allow"
          Resource = "${aws_s3_bucket.img_mgr_bucket.arn}/*"
        },
        {
          Action   = ["s3:ListBucket"]
          Effect   = "Allow"
          Resource = aws_s3_bucket.img_mgr_bucket.arn
        },
        {
          Action   = ["ec2:DescribeTags"]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}
resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.node.name
}
resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.node.name
}
resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.node.name
}
resource "aws_iam_instance_profile" "node" {
  role = aws_iam_role.node.name
}
