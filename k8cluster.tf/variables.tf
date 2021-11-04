variable "region" {}
variable "environment" {}
variable "namespace" {}
variable "instance_type" {
  description = "list of instance types allowed for autoscale group"
  type        = string
  default     = "t2.small"

  validation {
    condition     = contains(["t3.micro", "t3.small", "t2.micro", "t2.small"], var.instance_type)
    error_message = "Instance type not allowed..."
  }
}
variable "desired_capacity" {
  description = "number of ideal nodes during normal load"
  default = 3
}
variable "max_capacity" {
  description = "max number of nodes"
  default = 10
}
variable "min_capacity" {
  description = "min number of nodes to have running"
  default = 1
}
locals {
  cluster_name = "${var.namespace}-${var.environment}"
}
locals {
  arnsplit = split("/", data.aws_caller_identity.current.arn)
  username = element(local.arnsplit, length(local.arnsplit)-1)
}
