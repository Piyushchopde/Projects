# This is for AWS Dyanamic AMI 
data "aws_ami" "dyanamic-Ec2" {
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "name"
      values = ["al2023-ami-*-x86_64"]
    }

    filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#Lambda Function .py file convert to ZIP
data "archive_file" "lambda_startec2_archive" {
    type = "zip"
    source_file = "lambda_startec2.py"
    output_path = "lambda_startec2load.zip"
}

data "archive_file" "lambda_stopec2_archive" {
    type = "zip"
    source_file = "lambda_stopec2.py"
    output_path = "lambda_stopec2load.zip"
}

# Assume Role Policy 
data "aws_iam_policy_document" "assume_role"{
  statement {
    effect = "Allow"
  
  principals {
    type = "Service"
    identifiers = ["lambda.amazonaws.com"]
  }

  actions = ["sts:AssumeRole"]

  }
}

