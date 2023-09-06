# creates the kms key
resource "aws_kms_key" "RamData_key" {
  description             = "RamData KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

# creates the bucket 
resource "aws_s3_bucket" "RamData_bucket" {
  bucket = var.S3_BUCKET_NAME
}

# creates the configuration needed for the encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "RamData_S3_Encryption" {
  bucket = aws_s3_bucket.RamData_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.RamData_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# creates a folder inside the bucket
resource "aws_s3_object" "Ram_Data" {
  bucket = aws_s3_bucket.RamData_bucket.id
  key    = "RamData/"
}
