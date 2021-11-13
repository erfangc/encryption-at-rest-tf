resource "aws_kms_key" "cmk" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
  policy                  = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowAdminKmsKey"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action    = "kms:*"
        Resource  = "*"
      },
      {
        Sid       = "Allow access through Amazon DynamoDB for all principals in the account that are authorized to use Amazon DynamoDB",
        Effect    = "Allow",
        Principal = {
          "AWS" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/dynamodb-user"
        },
        Action    = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ],
        Resource  = "*",
        Condition = {
          StringLike = {
            "kms:ViaService" = "dynamodb.*.amazonaws.com"
          }
        }
      }
    ]
  })
}