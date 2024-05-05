# This Policy for Lamda function should STOP and START EC2 Instance  

resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
  
}


resource "aws_iam_policy" "policy_for_lambda" {
  name        = "policy_for_lambda"
  description = "A policy to allow lambda to start and stop EC2 instances, as well as access logs"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:Start*",
          "ec2:Stop*",
          "ec2:Describe*"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        "Resource": "arn:aws:logs:::*",
        "Effect": "Allow"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy_to_iam_for_lambda" {
  policy_arn = aws_iam_policy.policy_for_lambda.arn
  role       = aws_iam_role.iam_for_lambda.name
}



# This Policy is For Invoke Lambda function 
resource "aws_iam_role" "scheduler" {
  name = "cron-scheduler-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["scheduler.amazonaws.com"]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "scheduler_policy" {
  name        = "scheduler_policy"
  description = "A policy to allow scheduler to start and stop EC2 instances"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "lambda:InvokeFunction"
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy_to_scheduler" {
  policy_arn = aws_iam_policy.scheduler_policy.arn
  role       = aws_iam_role.scheduler.name
}