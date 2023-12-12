terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "<YOUR STATE BUCKET>"
    region = "us-east-2"
    key    = "terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

# ----- api gateway -----

resource "aws_apigatewayv2_api" "backend" {
  name          = "<YOUR API GW NAME>"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.backend.id
  name        = "$default"
  auto_deploy = true
}

# ------ endpoints ------

module "hello-world" {
  source = "./service"

  api_id   = aws_apigatewayv2_api.backend.id
  name     = "hello-world"
  path     = "../src/hello-world"
  routes   = ["GET /hello-world"]
}

