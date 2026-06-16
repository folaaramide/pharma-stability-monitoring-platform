data "archive_file" "submit_result_zip" {
  type        = "zip"
  source_file = "../lambda/submit_result.py"
  output_path = "../lambda/submit_result.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "stability_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {

  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name = "lambda-dynamodb-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "sns:Publish"
        ]

        Resource = [
          aws_dynamodb_table.stability_results.arn,
          aws_sns_topic.stability_alerts.arn
        ]
      }
    ]
  })
}

resource "aws_lambda_function" "submit_result" {
  function_name = "submit-result"

  filename         = data.archive_file.submit_result_zip.output_path
  source_code_hash = data.archive_file.submit_result_zip.output_base64sha256

  role = aws_iam_role.lambda_role.arn

  handler = "submit_result.lambda_handler"

  runtime = "python3.13"

  environment {

    variables = {

      TOPIC_ARN = aws_sns_topic.stability_alerts.arn

    }

  }

  vpc_config {
    subnet_ids = [
      aws_subnet.private_subnet_a.id,
      aws_subnet.private_subnet_b.id
    ]

    security_group_ids = [
      aws_security_group.lambda_sg.id
    ]
  }

}

resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
