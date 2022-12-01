variable "region" {
  description = "Availability Zone"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "AWS environment to be identified for resources i.e. dev,qa,staging,test ... (use lowercase)"
  type        = string
  default     = "uat"
}
