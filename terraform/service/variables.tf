variable "api_id" {
  type        = string
  description = "The api that owns this page"
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the lambda"
  nullable    = false
}

variable "path" {
  type        = string
  description = "The path to the directory containing the lambda's source code"
  nullable    = false
}

variable "routes" {
  type        = list(string)
  description = "The routes handled by this endpoint"
  nullable    = false
}

variable "additional_policy_arns" {
  type        = list(string)
  description = "Additional IAM policy ARNs to attach to the lambda"
  default     = []
}

variable "env_vars" {
  type = map(string)
  description = "Environment variables for the lambda"
  default = {}
}
