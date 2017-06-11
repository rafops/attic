# Terraform

- Configuration in two formats: `.tf` (HCL) and `.tf.json`


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


## Deploy

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


## Destroy

```
terraform plan -out destroy.terraform -destroy
```

```
terraform apply destroy.terraform
```


## Change

Update scripts then:

```
terraform plan -out changes.terraform
```

```
terraform apply changes.terraform
```


## Modules

Creating a Consul cluster:

```
# consul.tf
module "consul" {
  source  = "github.com/hashicorp/consul/terraform/aws"
  servers = 2
  key_name = "consul"
  key_path = "consul_rsa_key"
  platform = "ubuntu"
}
```

Download module:

```
terraform get
```

Create keys:

```
ssh-keygen -P '' -t rsa -f consul_rsa_key
```

Plan:

```
terraform plan -out plan.terraform
```


## VPC

```
https://github.com/terraform-community-modules/tf_aws_vpc
```


## Packer

```
packer build -machine-readable packer.json
```

Generate AMI, then is necessary to create a variable with the new AMI for terraform apply.


## Graph

```
brew install graphviz
terraform graph | dot -Tpng > graph.png
```
