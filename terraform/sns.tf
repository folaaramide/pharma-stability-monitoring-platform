resource "aws_sns_topic" "stability_alerts" {
  name = "stability-alerts"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.stability_alerts.arn
  protocol  = "email"
  endpoint  = "afolabiaramide@outlook.com"
}