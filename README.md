# Microservice API Scaffold

A barebones scaffold to quickly initialize a new microservice monorepo project.

## Requirements

- NodeJS 18+
- [terraform](https://github.com/hashicorp/terraform)
- An AWS account with the necessary [environment variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html#envvars-set) set up in your shell session
- An existing S3 bucket for the Terraform state

## Resource Overview

The primary resource created by this project is an AWS API Gateway v2 backed by any
number of Lambdas that handle the individual API routes
(see [`terraform/main.tf`](./terraform/main.tf) and [`terraform/service/main.tf`](./terraform/service/main.tf)).

## Set up

1. Change the `<YOUR STATE BUCKET>` and `<YOUR API GW NAME>` to their corresponding values in [`terraform/main.tf`](./terraform/main.tf)
2. Run `./build.sh`

## Deploying

```bash
./build.sh
terraform -chdir=terraform apply
```

