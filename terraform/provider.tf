provider "aws" {
  access_key = "mock_access_key"
  secret_key = "mock_secret_key"
  region     = "us-east-1"

  # s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2             = "http://ec2.localhost.localstack.cloud:4566"
    s3              = "http://s3.localhost.localstack.cloud:4566"
    sts             = "http://sts.localhost.localstack.cloud:4566"
    route53         = "http://route53.localhost.localstack.cloud:4566"
    s3control       = "http://s3-control.localhost.localstack.cloud:4566"
    route53resolver = "http://route53resolver.localhost.localstack.cloud:4566"
    iam             = "http://iam.localhost.localstack.cloud:4566"
    lambda = "http://lambda.localhost.localstack.cloud:4566"
    cloudformation = "http://cloudformation.localhost.localstack.cloud:4566"
    apigateway     = "http://apigateway.localhost.localstack.cloud:4566"
    cloudwatch     = "http://cloudwatch.localhost.localstack.cloud:4566"
    events         = "http://events.localhost.localstack.cloud:4566"
    sns            = "http://sns.localhost.localstack.cloud:4566"
    sqs            = "http://sqs.localhost.localstack.cloud:4566"
    ssm            = "http://ssm.localhost.localstack.cloud:4566"
    secretsmanager = "http://secretsmanager.localhost.localstack.cloud:4566"
    kinesis        = "http://kinesis.localhost.localstack.cloud:4566"
    firehose       = "http://firehose.localhost.localstack.cloud:4566"
    dynamodb       = "http://dynamodb.localhost.localstack.cloud:4566"
    es             = "http://es.localhost.localstack.cloud:4566"
    kinesisanalytics = "http://kinesisanalytics.localhost.localstack.cloud:4566"
    stepfunctions = "http://stepfunctions.localhost.localstack.cloud:4566"

  }

  default_tags {
    tags = {
      Environment = "local"
      Service     = "LocalStack"
    }
  }
}

terraform {
  required_version = ">= 1.2.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.60.0, < 4.22.0"
    }
  }
}