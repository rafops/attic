# Terraform

## Install

Follow HashiCorp on Keybase and install Terraform:

```bash
brew install tfenv
tfenv install 0.10.6
tfenv use 0.10.6
```

## Initialize

```
terraform init
terraform get
terraform plan
terraform apply
```

## Merging Tags

```
resource "aws_…" "…" {
  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}
```

## VPC

### Do not create IGW if there is no public subnet

```
resource "aws_internet_gateway" "igw" {
  count = "${length(var.public_subnets) > 0 ? 1 : 0}"
}
```

## Graph

```
brew install graphviz
terraform graph | dot -Tpng > graph.png
```

## Module from Git

```
module "test-vpc" {
  source = "git::ssh://git@github.com/mytfmodule.git//modules/vpc?ref=a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0"
}
```

## Basic Module

```
terraform {
  required_version = "~> 0.10.4"
}

variable "name" {
}
variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

data "aws_availability_zones" "availability_zones" {}

locals {
  availability_zones = "${data.aws_availability_zones.availability_zones.names}"
  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

resource "aws_…" "…" {
  tags = "${local.tags}"
}

output "id" {
  value = "${aws_….….id}"
}
```
