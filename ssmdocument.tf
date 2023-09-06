# SSM Document for running the command on the instance 
resource "aws_ssm_document" "ram2s3_ssm_document" {
  name          = "Ram2S3_SSM_Document"
  document_type = "Command"
  content = jsonencode({
    schemaVersion = "2.2",
    description   = "Command Document Take RAM and send to S3",
    mainSteps = [
      {
        action = "aws:runShellScript",
        name   = "Ram2S3_SSM_Document",
        inputs = {
          runCommand = [
            "sudo insmod /home/ec2-user/LiME/src/lime-6.1.41-63.114.amzn2023.x86_64.ko 'path=./ramdata.mem format=raw' && aws s3 cp ramdata.mem s3://limerambkt/LIMERAM/ramdata.mem"
          ]
        }
      }
    ],
    parameters = {
      Message = {
        type        = "String",
        description = "Example",
        default     = "None"
      }
    }
  })
}

# SSM association to instance and SSM document 
resource "aws_ssm_association" "ram2s3_association" {
  name             = aws_ssm_document.ram2s3_ssm_document.name
  document_version = "$LATEST"
  targets {
    key    = "InstanceIds"
    values = [var.INSTANCE_ID]
  }
  depends_on = [aws_ssm_document.ram2s3_ssm_document]
}
