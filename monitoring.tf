# CloudWatch CPU alarms for the servers

# CPU alarm for each server, goes off when average CPU stays above the threshold for 5 min
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  for_each = aws_instance.web

  alarm_name          = "${local.name}-${each.key}-high-cpu"
  alarm_description   = "CPU above ${var.cpu_alarm_threshold}% on ${local.name}-${each.key}"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.cpu_alarm_threshold
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = each.value.id
  }
}
