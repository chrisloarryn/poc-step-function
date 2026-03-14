locals {
  name_prefix        = "${var.project_name}-${var.environment}"
  state_machine_name = "${local.name_prefix}-calculator"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Repository  = "poc-step-function"
  }

  lambda_definitions = {
    validate_request = {
      build_dir   = "01_validate_request_ts"
      short_name  = "validate-request"
      description = "Validates and normalizes calculator requests."
      runtime     = "nodejs22.x"
      handler     = "main.handler"
    }
    add = {
      build_dir   = "02_add_go"
      short_name  = "add"
      description = "Adds two numbers using Go."
      runtime     = "provided.al2023"
      handler     = "bootstrap"
    }
    subtract = {
      build_dir   = "03_subtract_rust"
      short_name  = "subtract"
      description = "Subtracts two numbers using Rust."
      runtime     = "provided.al2023"
      handler     = "bootstrap"
    }
    multiply = {
      build_dir   = "04_multiply_python"
      short_name  = "multiply"
      description = "Multiplies two numbers using Python."
      runtime     = "python3.12"
      handler     = "main.handler"
    }
    divide = {
      build_dir   = "05_divide_node"
      short_name  = "divide"
      description = "Divides two numbers using Node.js."
      runtime     = "nodejs22.x"
      handler     = "main.handler"
    }
    percentage = {
      build_dir   = "06_percentage_ts"
      short_name  = "percentage"
      description = "Calculates a percentage using TypeScript."
      runtime     = "nodejs22.x"
      handler     = "main.handler"
    }
    format_result = {
      build_dir   = "07_format_result_node"
      short_name  = "format-result"
      description = "Builds the final calculator response."
      runtime     = "nodejs22.x"
      handler     = "main.handler"
    }
  }

  lambda_function_names = {
    for key, lambda in local.lambda_definitions :
    key => "${local.name_prefix}-${lambda.short_name}"
  }

  lambda_retry = [
    {
      ErrorEquals     = ["Lambda.ServiceException", "Lambda.AWSLambdaException", "Lambda.SdkClientException"]
      IntervalSeconds = 2
      MaxAttempts     = 2
      BackoffRate     = 2
    }
  ]

  lambda_source_files = sort(fileset("${path.module}/../lambdas", "**"))

  lambda_source_hash = sha1(join("", concat(
    [
      filesha1("${path.module}/../package.json"),
      filesha1("${path.module}/../package-lock.json"),
      filesha1("${path.module}/../scripts/build_lambdas.sh"),
    ],
    [for file in local.lambda_source_files : filesha1("${path.module}/../lambdas/${file}")]
  )))
}
