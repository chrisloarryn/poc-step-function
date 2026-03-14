variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Base name used for AWS resources."
  type        = string
  default     = "poc-step-function-calculator"
}

variable "environment" {
  description = "Environment suffix used in resource names and tags."
  type        = string
  default     = "dev"
}

variable "lambda_runtime" {
  description = "Default runtime for Node.js based Lambda functions."
  type        = string
  default     = "nodejs22.x"
}

variable "lambda_timeout" {
  description = "Timeout in seconds for the Lambda functions."
  type        = number
  default     = 10
}

variable "lambda_memory_size" {
  description = "Memory size in MB for the Lambda functions."
  type        = number
  default     = 128
}

variable "log_retention_days" {
  description = "Retention in days for CloudWatch log groups."
  type        = number
  default     = 14
}
