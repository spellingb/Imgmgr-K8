variable "environment" {
    type = string
    description = "working environment. dev, prod, staging, test"
}
variable "namespace" {
    type = string
    description = "The name that will be prepended to items build by this module."
}
variable "region" {
    description   = "AWS region"
    type          = string
    default       = "us-west-1"
}

variable "CiderBlock" {
    type    = string
    description = "the first two octets of the ciderblock that will make up the vpc. eg: 10.100"
}

locals {
    priv = 100
    pub = 200
    maxsubnets = 3
}

locals {
    availability_zones = data.aws_availability_zones.availability_zones.names
}

locals {
    priv_networks = [
        for az in local.availability_zones:
            "${var.CiderBlock}.${local.priv + index(local.availability_zones, az)}.0/24"
            if index(local.availability_zones, az) < local.maxsubnets
    ]
    pub_networks = [
        for az in local.availability_zones:
            "${var.CiderBlock}.${local.pub + index(local.availability_zones, az)}.0/24"
            if index(local.availability_zones, az) < local.maxsubnets
    ]
}
