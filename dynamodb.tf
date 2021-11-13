
resource "aws_dynamodb_table" "books" {
  name         = "books"
  hash_key     = "country"
  range_key    = "isbnNumber"
  attribute {
    name = "country"
    type = "S"
  }
  attribute {
    name = "isbnNumber"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.cmk.arn
  }
}
