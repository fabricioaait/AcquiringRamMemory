resource "aws_iam_instance_profile" "GetRamData_instance_profile" {
  name = "GetRamData_InstanceProfile"
  role = aws_iam_role.GetRamData_role.name
}

resource "aws_iam_role" "GetRamData_role" {
  name = "GetRamData_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# iam s3 put policy
resource "aws_iam_policy" "s3_put_policy" {
  name        = "S3PutPolicy"
  description = "Policy to permit S3 PutObject"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:CreateMultipartUpload",
          "s3:AbortMultipartUpload",
          "s3:ListBucketMultipartUploads",
          "s3:ListMultipartUploadParts"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.RamData_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.RamData_bucket.bucket}/*"
        ],
        "Effect" : "Allow"
      }
    ]
  })
}

# IAM KMS policy
resource "aws_iam_policy" "kms_policy" {
  name        = "KmsPolicy"
  description = "Policy to permit KMS operations"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}

#Attachments 
resource "aws_iam_policy_attachment" "attach_policies" {
  name       = "attachpolicies"
  roles      = [aws_iam_role.GetRamData_role.name]
  /* policy_arn = aws_iam_policy.ssm_policy.arn */
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "attach_s3_put_policy" {
  name       = "attachs3putpolicy"
  roles      = [aws_iam_role.GetRamData_role.name]
  policy_arn = aws_iam_policy.s3_put_policy.arn
}

resource "aws_iam_policy_attachment" "attach_kms_policy" {
  name       = "attachs3putpolicy"
  roles      = [aws_iam_role.GetRamData_role.name]
  policy_arn = aws_iam_policy.kms_policy.arn
}
