variable "lambda_function_name" {
  description       = "A name for the lambda"  
}

variable "lambda_description" {
    default         = "Some description for your lambda"
    description     = "Some description for your lambda"
}  

 variable "lambda_code_path" {
    description     = "The path to your lamda code"
} 

variable "lambda_handler" {
  description       = "Lambda handler, e.g: lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description       = "Runtime of the lambda, e.g: python3.8"
}

variable "lambda_policy_arn" {
  description     = "The ARNs of the policies to attach to the lambda role"
  type            = list(string)
}

variable "api_gateway_id" {
  description   = "The id of the api gateway resource"
}

variable "api_gateway_root_resource_id" {
  description   = "The parent resource id of the api gateway"  
}

variable "resource_path" {
  description    = "A path to the resource"
  default        = "path"
}

variable "request_method" {
  description    = "The http request method, e.g: GET"
}

variable "authorizer_id" {
  description     = "The id of the authorizer"
  default         = ""
}

variable "stage_name" {
  description     = "The name of the stage to be deployed"
}

variable "region" {
  description     = "Region where your lambda is deployed, e.g: us-east-1"
}

variable "account_id" {
  description     = "Your account id"
}

variable "api_gateway_resource_id" {
  description     = "The id of your resource , if not specified one it is going to be created"
  default         = ""
}


variable "api_gateway_resource_path" {
  description     = "The path of your resource , if not specified one it is going to be created"
  default         = "" 
}
