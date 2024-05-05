resource "aws_scheduler_schedule" "start_ec2_schedule" {
    name = "Start-Ec2-Schedule"
    schedule_expression = "cron(0 9 ? * MON-FRI *)"

    flexible_time_window {
      mode = "OFF"
    }

    target {
      role_arn = aws_iam_role.scheduler.arn
      arn = aws_lambda_function.lambda_startec2.arn
    }
}

resource "aws_scheduler_schedule" "stop_ec2_schedule" {
    name = "Stop-Ec2-Schedule"
    schedule_expression = "cron(0 17 ? * MON-FRI *)"

    flexible_time_window {
      mode = "OFF"
    }

    target {
      role_arn = aws_iam_role.scheduler.arn
      arn = aws_lambda_function.lambda_stopec2.arn
    }
}