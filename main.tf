provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "test" {
    ami = "ami-08e5424edfe926b43"
    instance_type = "t2.micro" 

     tags = {
    Name = "lakshman"
    }
}

   