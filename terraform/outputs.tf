output "lambda_function_names" {
  description = "Lambda function names created by this stack."
  value       = local.lambda_function_names
}

output "state_machine_name" {
  description = "Name of the Step Functions state machine."
  value       = aws_sfn_state_machine.number_processor.name
}

output "state_machine_arn" {
  description = "ARN of the Step Functions state machine."
  value       = aws_sfn_state_machine.number_processor.arn
}

output "sample_execution_input" {
  description = "Sample payload you can send to the Step Functions state machine."
  value = {
    left      = 120
    right     = 15
    operation = "percentage"
  }
}
