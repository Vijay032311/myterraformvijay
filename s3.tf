resource "aws_s3_bucket" "vanbuc" {
  bucket = "testbuc"

  tags = {
    Name        = "vanbuc"
    Environment = "Dev"
  }
}
resource "aws_s3_object" "vanobj" {
  bucket = "testbuc"
}
