resource "aws_api_gateway_resource" "api_gateway_resource" {
  count =  length(var.api_gateway_id) > 0  && var.api_gateway_resource_id == "" ? 1 : 0
  
  rest_api_id =  var.api_gateway_id
  parent_id   =  var.api_gateway_root_resource_id
  path_part   =  var.resource_path
}

resource "aws_api_gateway_method" "api_gateway_method" {
  count = length(var.api_gateway_id) > 0 ? 1 : 0

  rest_api_id   = var.api_gateway_id
  resource_id   = length(var.api_gateway_resource_id) == 0 ? aws_api_gateway_resource.api_gateway_resource[0].id : var.api_gateway_resource_id
  http_method   = var.request_method
  authorization = length(var.authorizer_id) > 0 ? "COGNITO_USER_POOLS" : "NONE"
  authorizer_id = length(var.authorizer_id) > 0 ? var.authorizer_id : ""
}

resource "aws_api_gateway_integration" "integration" {
  count = length(var.api_gateway_id) > 0 ? 1 : 0

  rest_api_id             = var.api_gateway_id
  resource_id             = length(var.api_gateway_resource_id) == 0 ? aws_api_gateway_resource.api_gateway_resource[0].id : var.api_gateway_resource_id
  http_method             = var.request_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  count = length(var.api_gateway_id) > 0 ? 1 : 0
  depends_on = [aws_api_gateway_integration.integration]

  rest_api_id = var.api_gateway_id
  stage_name  = var.stage_name
}


## adding CORs support ##

resource "aws_api_gateway_method" "cors_method" {
  count =  var.cors_enable && length(var.api_gateway_id) > 0  && length(var.api_gateway_resource_id) == 0 ? 1 : 0

  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.api_gateway_resource[0].id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# aws_api_gateway_integration.
resource "aws_api_gateway_integration" "cors_integration" {
  count =  var.cors_enable && length(var.api_gateway_id) > 0  && length(var.api_gateway_resource_id) == 0 ? 1 : 0

  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.api_gateway_resource[0].id
  http_method = aws_api_gateway_method.cors_method[0].http_method

  type = "MOCK"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

# aws_api_gateway_integration_response._
resource "aws_api_gateway_integration_response" "cors_response" {
  count =  var.cors_enable && length(var.api_gateway_id) > 0  && length(var.api_gateway_resource_id) == 0 ? 1 : 0

  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.api_gateway_resource[0].id
  http_method = aws_api_gateway_method.cors_method[0].http_method
  status_code = 200

  response_parameters = local.integration_response_parameters

  depends_on = [aws_api_gateway_integration.cors_integration, aws_api_gateway_method_response.cors_method_response]
}

# aws_api_gateway_method_response._
resource "aws_api_gateway_method_response" "cors_method_response" {
  count =  var.cors_enable && length(var.api_gateway_id) > 0  && length(var.api_gateway_resource_id) == 0 ? 1 : 0

  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.api_gateway_resource[0].id
  http_method = aws_api_gateway_method.cors_method[0].http_method
  status_code = 200

  response_parameters = local.method_response_parameters

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [aws_api_gateway_method.cors_method]
}