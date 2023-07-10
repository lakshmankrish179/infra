output "public_ip" {
    description = "The Public IP address"
    value = aws_instance.test.public_ip
  
}