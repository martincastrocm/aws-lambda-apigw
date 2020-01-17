resource "aws_api_gateway_resource" "api_gateway_resource" {
  rest_api_id =  var.api_gateway_id
  parent_id   =  var.api_gateway_root_resource_id
  path_part   =  var.resource_path
}

resource "aws_api_gateway_method" "api_gateway_method" {
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.api_gateway_resource.id
  http_method   = var.request_method
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = var.authorizer_id
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = var.api_gateway_id
  resource_id             = aws_api_gateway_resource.api_gateway_resource.id
  http_method             = var.request_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "basewebapp_apigw_deployment" {
  depends_on = [aws_api_gateway_integration.integration]

  rest_api_id = var.api_gateway_id
  stage_name  = var.stage_name
}

