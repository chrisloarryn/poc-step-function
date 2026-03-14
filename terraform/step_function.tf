resource "aws_sfn_state_machine" "number_processor" {
  name     = local.state_machine_name
  role_arn = aws_iam_role.step_functions.arn
  type     = "STANDARD"

  definition = jsonencode({
    Comment = "Routes calculator operations to the Lambda implemented in the matching runtime."
    StartAt = "ValidateRequest"
    States = {
      ValidateRequest = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = aws_lambda_function.this["validate_request"].arn
          "Payload.$"  = "$"
        }
        OutputPath = "$.Payload"
        Retry      = local.lambda_retry
        Next       = "RouteOperation"
      }
      RouteOperation = {
        Type = "Choice"
        Choices = [
          {
            Variable     = "$.operation"
            StringEquals = "add"
            Next         = "AddNumbers"
          },
          {
            Variable     = "$.operation"
            StringEquals = "subtract"
            Next         = "SubtractNumbers"
          },
          {
            Variable     = "$.operation"
            StringEquals = "multiply"
            Next         = "MultiplyNumbers"
          },
          {
            Variable     = "$.operation"
            StringEquals = "divide"
            Next         = "DivideNumbers"
          },
          {
            Variable     = "$.operation"
            StringEquals = "percentage"
            Next         = "CalculatePercentage"
          },
        ]
        Default = "UnsupportedOperation"
      }
      AddNumbers = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = aws_lambda_function.this["add"].arn
          "Payload.$"  = "$"
        }
        OutputPath = "$.Payload"
        Retry      = local.lambda_retry
        Next       = "FormatResult"
      }
      SubtractNumbers = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = aws_lambda_function.this["subtract"].arn
          "Payload.$"  = "$"
        }
        OutputPath = "$.Payload"
        Retry      = local.lambda_retry
        Next       = "FormatResult"
      }
      MultiplyNumbers = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = aws_lambda_function.this["multiply"].arn
          "Payload.$"  = "$"
        }
        OutputPath = "$.Payload"
        Retry      = local.lambda_retry
        Next       = "FormatResult"
      }
      DivideNumbers = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = aws_lambda_function.this["divide"].arn
          "Payload.$"  = "$"
        }
        OutputPath = "$.Payload"
        Retry      = local.lambda_retry
        Next       = "FormatResult"
      }
      CalculatePercentage = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = aws_lambda_function.this["percentage"].arn
          "Payload.$"  = "$"
        }
        OutputPath = "$.Payload"
        Retry      = local.lambda_retry
        Next       = "FormatResult"
      }
      FormatResult = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = aws_lambda_function.this["format_result"].arn
          "Payload.$"  = "$"
        }
        OutputPath = "$.Payload"
        Retry      = local.lambda_retry
        End        = true
      }
      UnsupportedOperation = {
        Type  = "Fail"
        Error = "UnsupportedOperation"
        Cause = "The requested calculator operation is not supported."
      }
    }
  })

  logging_configuration {
    include_execution_data = true
    level                  = "ALL"
    log_destination        = "${aws_cloudwatch_log_group.step_functions.arn}:*"
  }

  depends_on = [
    aws_iam_role_policy_attachment.step_functions_invoke_lambda,
    aws_iam_role_policy_attachment.step_functions_logging,
  ]
}
