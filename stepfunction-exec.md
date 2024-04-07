
# Step Function Execution

## Step Function created in LocalStack

### Step Function Definition

```json
{
    "stateMachineArn": "arn:aws:states:us-east-1:000000000000:stateMachine:NumberProcessorSF",
    "name": "NumberProcessorSF",
    "status": "ACTIVE",
    "definition": "{\n  \"Comment\": \"Ejecuta las Lambdas seg<C3><BA>n si el n<C3><BA>mero es par o impar\",\n  \"StartAt\": \"NumberGenerator\",\n  \"States\": {\n    \"NumberGenerator\": {\n      \"Type\": \"Task\",\n      \"Resource\": \"arn:aws:lambda:us-east-1:000000000000:function:poc_number_generator_lambda\",\n      \"Next\": \"IsNumberEven\"\n    },\n    \"IsNumberEven\": {\n      \"Type\": \"Choice\",\n      \"Choices\": [\n        {\n          \"Variable\": \"$.is_even\",\n          \"BooleanEquals\": true,\n          \"Next\": \"Even\"\n        }\n      ],\n      \"Default\": \"Odd\"\n    },\n    \"Even\": {\n      \"Type\": \"Task\",\n      \"Resource\": \"arn:aws:lambda:us-east-1:000000000000:function:poc_even_lambda\",\n      \"End\": true\n    },\n    \"Odd\": {\n      \"Type\": \"Task\",\n      \"Resource\": \"arn:aws:lambda:us-east-1:000000000000:function:poc_odd_lambda\",\n      \"End\": true\n    }\n  }\n}\n",
    "roleArn": "arn:aws:iam::000000000000:role/step_functions_role_poc_number_sf",
    "type": "STANDARD",
    "creationDate": "2024-04-07T10:05:06.325416-04:00"
}
```

### Step function tutorial provided by LocalStack

https://docs.localstack.cloud/user-guide/aws/stepfunctions/


### Step Function creation and execution history
```bash
  315  ls
  316  tf init
  317  cd terraform
  318  ls
  319  tf init
  320  tf plan
  321  tf init
  322  tf plan
  323  tf fmt
  324  tf plan
  325  tf apply -auto-approve
  326  tf destroy
  327  tf plan
  328  tf apply -auto-approve
  329* awslocal stepfunctions describe-state-machine --state-machine-arn "\n
  330* awslocal stepfunctions describe-state-machine --state-machine-arn ""\n
  345* sudo apt install pipx\npipx ensurepath\n
  347* pipx ensurepath
  351* pipx install awscli-local\n
  356  awslocal stepfunctions describe-state-machine --state-machine-arn "arn:aws:states:us-east-1:000000000000:stateMachine:NumberProcessorSF"\n
  357  awslocal stepfunctions list-state-machines
  358  awslocal stepfunctions start-execution \\n    --state-machine-arn "arn:aws:states:us-east-1:000000000000:stateMachine:NumberProcessorSF"
  359  awslocal stepfunctions describe-execution \\n        --execution-arn "arn:aws:states:us-east-1:000000000000:stateMachine:NumberProcessorSF"
  360  awslocal stepfunctions start-execution \\n    --state-machine-arn "arn:aws:states:us-east-1:000000000000:stateMachine:NumberProcessorSF"
  361  awslocal stepfunctions describe-execution \\n        --execution-arn "arn:aws:states:us-east-1:000000000000:stateMachine:NumberProcessorSF"
```