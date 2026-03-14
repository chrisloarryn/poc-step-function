resource "aws_lambda_function" "this" {
  for_each = local.lambda_definitions

  function_name = local.lambda_function_names[each.key]
  description   = each.value.description
  role          = aws_iam_role.lambda_execution.arn
  handler       = each.value.handler
  runtime       = each.value.runtime

  filename         = data.archive_file.lambda[each.key].output_path
  source_code_hash = data.archive_file.lambda[each.key].output_base64sha256

  architectures = ["x86_64"]
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout

  depends_on = [
    terraform_data.build_lambdas,
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy_attachment.lambda_basic_execution,
  ]
}
