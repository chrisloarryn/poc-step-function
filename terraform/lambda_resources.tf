resource "terraform_data" "build_lambdas" {
  triggers_replace = {
    source_hash = local.lambda_source_hash
  }

  provisioner "local-exec" {
    command     = "./scripts/build_lambdas.sh"
    interpreter = ["/bin/bash", "-lc"]
    working_dir = "${path.module}/.."
  }
}

data "archive_file" "lambda" {
  for_each = local.lambda_definitions

  type        = "zip"
  source_dir  = "${path.module}/../build/lambdas/${each.value.build_dir}"
  output_path = "${path.module}/.terraform/${each.key}.zip"

  depends_on = [terraform_data.build_lambdas]
}
