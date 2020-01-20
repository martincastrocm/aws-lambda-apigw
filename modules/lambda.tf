data "archive_file" "lambda_zip" {
    type        = "zip"
    source_dir  = var.lambda_code_path
    output_path = "${var.lambda_function_name}.zip"
}

resource "aws_lambda_function" "lambda" {
  filename          = "${var.lambda_function_name}.zip"
  source_code_hash  = data.archive_file.lambda_zip.output_base64sha256
  function_name     = var.lambda_function_name
  role              = aws_iam_role.lambda_role.arn
  description       = var.lambda_description
  handler           = var.lambda_handler
  runtime           = var.lambda_runtime
  tags              = var.tags
  
  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]
    content {
      variables = environment.value.variables
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_cwgroup" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}


resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_function_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_iam_role_policy_attachment" {
    count         =   length(var.lambda_policy_arn)
    role          =   aws_iam_role.lambda_role.name
    policy_arn    =   var.lambda_policy_arn[count.index] #element(var.lambda_policy_arn, count.index)
}

## Lambda
resource "aws_lambda_permission" "lambda_permission" {

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${var.api_gateway_id}/*/${var.request_method}${length(var.api_gateway_resource_path) == 0 ? aws_api_gateway_resource.api_gateway_resource[0].path : var.api_gateway_resource_path}"
}
