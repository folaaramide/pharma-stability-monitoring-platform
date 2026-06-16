output "stability_table" {
  value = aws_dynamodb_table.stability_results.name
}

output "incident_table" {
  value = aws_dynamodb_table.incidents.name
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.stability_api.api_endpoint
}