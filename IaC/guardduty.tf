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
# -----------------------------------------------------------------------------

resource "aws_guardduty_detector" "main" {
  enable = true

  datasources {
    s3_logs {
      # Enables GuardDuty to monitor S3 data events for threats such as
      # unusual access patterns or data exfiltration attempts.
      enable = true
    }

    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          # Enables automated malware scanning on EC2 instance EBS volumes
          # when a GuardDuty finding is generated for that instance.
          enable = true
        }
      }
    }
  }
}
