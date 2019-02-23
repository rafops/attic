# Terragrunt

## Motivations

- “You can reduce the amount of copy paste using Terraform modules, but even
  the code to instantiate a module and set up input variables, output
  variables, providers, and remote state can still create a lot of maintenance
  overhead”.

## Questions

- How to encrypt S3 bucket with custom KMS key that is only accessible by Administrators?
- Alternatively, it is possible to make the default KMS key only accessible by Administrators?

## Setup

Unlink tfenv:

```
brew unlink tfenv
```

Install terragrunt:

```
brew install terragrunt
```

Create a `terraform.tfvars`:

```
terragrunt = {
}
```

Define IaC in a single repository called modules:

```
└── modules
    ├── app
    │   └── main.tf
    ├── mysql
    │   └── main.tf
    └── vpc
        └── main.tf
```

Anything in your code that should be different between environments should be exposed as an input variable.

```
# modules/app/main.tf

variable "instance_count" {
  description = "How many servers to run"
}
```

Create a separate repository with variables per component:

```
└── live
    ├── prod
        ├── terraform.tfvars ?
    │   ├── app
    │   │   └── terraform.tfvars
    │   ├── mysql
    │   │   └── terraform.tfvars
    │   └── vpc
    │       └── terraform.tfvars
```

```
# live/prod/app/terraform.tfvars
terragrunt = {
  terraform {
    source = "git::git@github.com:foo/modules.git//app?ref=v0.0.3"
  }
  # include terraform.tfvars from the prod folder
  include {
    path = "${find_in_parent_folders()}"
  }
}

instance_count = 3
```

Apply:

```
cd live/prod/app
terragrunt apply
```

Or specify path:

```
terragrunt apply -var-file live/prod/app/terraform.tfvars
```

To run locally during development:

```
cd live/prod/app
terragrunt apply --terragrunt-source ../../../modules//app
```

## Examples

Modules example: https://github.com/gruntwork-io/terragrunt-infrastructure-modules-example

Infrastructure example: https://github.com/gruntwork-io/terragrunt-infrastructure-live-example

This example suggest the following structure:

account
 └ _global
 └ region
    └ _global
    └ environment
       └ resource

Alternativelly it can be simplified to:

my-service-production
 └ _global
 └ resource
