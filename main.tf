
module "lambda" {
    source  = "./modules"

    lambda_function_name            = "${var.project}-${var.stage}-first-lambda"
    lambda_code_path                = "../lambdas/helloWorld"
    lambda_handler                  = "lambda_function.lambda_handler"
    lambda_runtime                  = "python3.8"
    lambda_policy_arn               = [aws_iam_policy.iampolicy_first_lambda.arn, aws_iam_policy.iampolicy_second_lambda.arn] 

    api_gateway_id                  = aws_api_gateway_rest_api.first_api_gateway.id
    api_gateway_root_resource_id    = aws_api_gateway_rest_api.first_api_gateway.root_resource_id
    resource_path                   = "first"
    request_method                  = "GET"
    authorizer_id                   = aws_api_gateway_authorizer.first_api_gateway_authorizer.id
    stage_name                      = "dev"
    region                          = var.region
    account_id                      =var.accountId

}


resource "aws_iam_policy" "iampolicy_first_lambda" {
  name        = "${var.project}-${var.stage}-first-lambda-policy"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "iampolicy_second_lambda" {
  name        = "${var.project}-${var.stage}-second-lambda-policy"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_api_gateway_rest_api" "first_api_gateway" {
  name        = "${var.project}-${var.stage}-first-api-gateway"
  description = "This is an apy for proobe the module"
}

resource "aws_api_gateway_authorizer" "first_api_gateway_authorizer" {
  name              = "${var.project}-${var.stage}-first-authoorizer"
  rest_api_id       = aws_api_gateway_rest_api.first_api_gateway.id
  type              = "COGNITO_USER_POOLS"
  provider_arns     = [var.user_pool_arn]
}