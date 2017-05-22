# Terraform

## Commands

```bash
terraform plan -out plan.terraform # plan
terraform apply plan.terraform     # apply plan
terraform show                     # show current state
cat terraform.tfstate              # show current state in JSON
```


## Getting started

Follow HashiCorp on Keybase and install Terraform:

```bash
brew install tfenv
tfenv install 0.9.5
tfenv use 0.9.5
```


## First Deploy

```
# instance.tf
resource "aws_instance" "example" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.nano"
}
```

```
# provider.tf
provider "aws" {
    region = "${var.AWS_REGION}"
    profile = "default"
}
```

```
# vars.tf
variable "AWS_REGION" {
  default = "ca-central-1"
}
variable "AMIS" {
  type = "map"
  default = {
    ca-central-1 = "ami-e273cf86"
  }
}
```

Plan:

```
terraform plan -out plan.terraform
```

Apply:

```
terraform apply plan.terraform
```
