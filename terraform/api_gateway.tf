resource "aws_apigatewayv2_api" "stability_api" {
  name          = "stability-api"
  protocol_type = "HTTP"

  cors_configuration {

    allow_origins = ["*"]

    allow_methods = ["POST"]

    allow_headers = ["content-type"]

  }

}

resource "aws_apigatewayv2_integration" "submit_result_integration" {
  api_id                 = aws_apigatewayv2_api.stability_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.submit_result.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "submit_route" {
  api_id    = aws_apigatewayv2_api.stability_api.id
  route_key = "POST /submit"
  target    = "integrations/${aws_apigatewayv2_integration.submit_result_integration.id}"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.stability_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.submit_result.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.stability_api.execution_arn}/*/*"
}
