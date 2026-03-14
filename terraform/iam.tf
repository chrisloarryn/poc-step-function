data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_execution" {
  name               = "${local.name_prefix}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "step_functions_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "step_functions" {
  name               = "${local.name_prefix}-step-functions-role"
  assume_role_policy = data.aws_iam_policy_document.step_functions_assume_role.json
}

data "aws_iam_policy_document" "step_functions_invoke_lambda" {
  statement {
    sid = "InvokeProjectLambdas"
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = flatten([
      for name in values(local.lambda_function_names) : [
        "arn:aws:lambda:*:*:function:${name}",
        "arn:aws:lambda:*:*:function:${name}:*",
      ]
    ])
  }
}

resource "aws_iam_policy" "step_functions_invoke_lambda" {
  name   = "${local.name_prefix}-step-functions-invoke-lambda"
  policy = data.aws_iam_policy_document.step_functions_invoke_lambda.json
}

resource "aws_iam_role_policy_attachment" "step_functions_invoke_lambda" {
  role       = aws_iam_role.step_functions.name
  policy_arn = aws_iam_policy.step_functions_invoke_lambda.arn
}

data "aws_iam_policy_document" "step_functions_logging" {
  statement {
    sid = "AllowStepFunctionsLogging"
    actions = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "step_functions_logging" {
  name   = "${local.name_prefix}-step-functions-logging"
  policy = data.aws_iam_policy_document.step_functions_logging.json
}

resource "aws_iam_role_policy_attachment" "step_functions_logging" {
  role       = aws_iam_role.step_functions.name
  policy_arn = aws_iam_policy.step_functions_logging.arn
}
