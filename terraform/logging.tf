resource "aws_cloudwatch_log_group" "lambda" {
  for_each = local.lambda_definitions

  name              = "/aws/lambda/${local.lambda_function_names[each.key]}"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_group" "step_functions" {
  name              = "/aws/vendedlogs/states/${local.state_machine_name}"
  retention_in_days = var.log_retention_days
}
