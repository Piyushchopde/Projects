resource "aws_lambda_function" "lambda_startec2" {
    filename = "lambda_startec2load.zip"
    function_name = "lambda_startec2"
    role = aws_iam_role.iam_for_lambda.arn
    handler = "lambda_startec2.lambda_handler"
    timeout = 10
    source_code_hash = data.archive_file.lambda_startec2_archive.output_base64sha256

    runtime = "python3.12"
}

resource "aws_lambda_function" "lambda_stopec2" {
    filename = "lambda_stopec2load.zip"
    function_name = "lambda_stopec2"
    role = aws_iam_role.iam_for_lambda.arn
    handler = "lambda_stop ec2.lambda_handler"
    timeout = 10
    source_code_hash = data.archive_file.lambda_stopec2_archive.output_base64sha256

    runtime = "python3.12"
}
