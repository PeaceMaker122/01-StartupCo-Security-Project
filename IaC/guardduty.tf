# -----------------------------------------------------------------------------
# AWS GuardDuty: AI Threat Detection Layer
#
# GuardDuty uses machine learning to continuously analyse CloudTrail logs,
# VPC Flow Logs, and DNS logs for anomalous or malicious activity.
#
# It complements the preventative controls already in place (IAM, MFA,
# least-privilege permissions) by adding a detective layer, catching threats
# that emerge after access is granted, such as compromised credentials,
# insider threats, or reconnaissance activity.
#
# GuardDuty requires no agents or additional infrastructure. It works
# passively in the background, making it low overhead and high value.
#
# Note: the datasources block inside aws_guardduty_detector is deprecated.
# Features are now managed as separate aws_guardduty_detector_feature resources.
# -----------------------------------------------------------------------------

resource "aws_guardduty_detector" "main" {
  enable = true
}

# Enables GuardDuty to monitor S3 data events for threats such as
# unusual access patterns or data exfiltration attempts.
resource "aws_guardduty_detector_feature" "s3_protection" {
  detector_id = aws_guardduty_detector.main.id
  name        = "S3_DATA_EVENTS"
  status      = "ENABLED"
}

# Enables automated malware scanning on EC2 instance EBS volumes
# when a GuardDuty finding is generated for that instance.
resource "aws_guardduty_detector_feature" "ebs_malware_protection" {
  detector_id = aws_guardduty_detector.main.id
  name        = "EBS_MALWARE_PROTECTION"
  status      = "ENABLED"
}
