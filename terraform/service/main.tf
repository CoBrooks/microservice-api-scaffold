data "aws_caller_identity" "current" { }

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "basic_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "handler_role" {
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json

  managed_policy_arns = concat(
    [data.aws_iam_policy.basic_execution_role.arn],
    var.additional_policy_arns
  )
}

resource "aws_apigatewayv2_route" "routes" {
  for_each  = toset(var.routes)

  api_id    = var.api_id
  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id                  = var.api_id
  integration_type        = "AWS_PROXY"
  integration_method      = "POST"
  integration_uri         = aws_lambda_function.handler.invoke_arn
  payload_format_version  = "2.0"
}

data "archive_file" "handler_zip" {
  type        = "zip"
  source_dir  = var.path
  output_path = ".build/${var.name}.zip"
}

resource "aws_lambda_function" "handler" {
  function_name = "${var.name}"
  handler       = "main.handler"
  runtime       = "nodejs18.x"

  filename         = data.archive_file.handler_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.handler_zip.output_path)

  role = aws_iam_role.handler_role.arn

  environment {
    variables = var.env_vars
  }
}

resource "aws_lambda_permission" "handler_permission" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.handler.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:us-east-2:${data.aws_caller_identity.current.account_id}:${var.api_id}/*/*"
}

