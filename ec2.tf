resource "aws_instance" "sampleint" {
  ami           = "ami-01dad638e8f31ab9a" # Change to the desired AMI ID
  instance_type = "t3.micro"             # Change to the desired instance type
  key_name      = "Vanjilinkeynew"   # Change to your SSH key pair name
}
