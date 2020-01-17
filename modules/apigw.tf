resource "aws_api_gateway_resource" "api_gateway_resource" {
  count = var.api_gateway_resource_id == "" ? 1 : 0
  
  rest_api_id =  var.api_gateway_id
  parent_id   =  var.api_gateway_root_resource_id
  path_part   =  var.resource_path
}

resource "aws_api_gateway_method" "api_gateway_method_authorized" {
  count = length(var.authorizer_id) > 0 ? 1 : 0 

  rest_api_id   = var.api_gateway_id
  resource_id   = length(var.api_gateway_resource_id) == 0 ? aws_api_gateway_resource.api_gateway_resource[0].id : var.api_gateway_resource_id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = var.authorizer_id
}

resource "aws_api_gateway_method" "api_gateway_method_unauthorized" {
  count = length(var.authorizer_id) == 0 ? 1 : 0 

  rest_api_id   = var.api_gateway_id
  resource_id   = length(var.api_gateway_resource_id) == 0 ? aws_api_gateway_resource.api_gateway_resource[0].id : var.api_gateway_resource_id
  http_method   = var.request_method
  authorization = "NONE"
  authorizer_id = var.authorizer_id
}

resource "aws_api_gateway_integration" "integration" {

  rest_api_id             = var.api_gateway_id
  resource_id             = length(var.api_gateway_resource_id) == 0 ? aws_api_gateway_resource.api_gateway_resource[0].id : var.api_gateway_resource_id
  http_method             = "GET"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}
resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on = [aws_api_gateway_integration.integration]

  rest_api_id = var.api_gateway_id
  stage_name  = var.stage_name
}