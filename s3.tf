resource "aws_s3_bucket" "vanbuc" {
  bucket = "vanbuc"
}
resource "aws_s3_object" "vanobj" {
  bucket = "vanbuc"
  key    = "vanobj"

}

