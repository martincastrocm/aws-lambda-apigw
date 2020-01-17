variable "region" {
  default = "us-east-1"
}
variable "credentials" {
  default = "~/.aws/credentials"
}

variable "profile" {
  default = "rook"
}

variable "stage" {
  default = "testing"
}

variable "project" {
  default = "MC-resources"
}

variable "accountId" {
  default = "785718762035"  
}

variable "name_apigw" {
  type      = string
  default   = "apigw"
}

variable "name_authorizer" {
  type      = string
  default   = "auth"
}

variable "user_pool_arn" {
  type      = string
  default   = "arn:aws:cognito-idp:us-east-1:785718762035:userpool/us-east-1_8iZdKn4Ii"       #"arn:aws:cognito-idp:us-east-1:785718762035:userpool/us-east-1_Dp4YmwHBu"
}