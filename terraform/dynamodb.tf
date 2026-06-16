resource "aws_dynamodb_table" "stability_results" {
  name         = "stability-results"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "batch_id"
  range_key    = "timepoint"

  attribute {
    name = "batch_id"
    type = "S"
  }

  attribute {
    name = "timepoint"
    type = "S"
  }
}


resource "aws_dynamodb_table" "incidents" {
  name         = "incidents"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "incident_id"

  attribute {
    name = "incident_id"
    type = "S"
  }
}