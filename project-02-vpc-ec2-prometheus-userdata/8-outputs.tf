output "public_instance_public_ip" {
  description = "Public IP of public EC2 instance"
  value       = aws_instance.terra-public-instance-1.public_ip
}

output "public_instance_private_ip" {
  description = "Private IP of public EC2 instance"
  value       = aws_instance.terra-public-instance-1.private_ip
}

output "private_instance_private_ip" {
  description = "Private IP of private EC2 instance"
  value       = aws_instance.terra-private-instance-1.private_ip
}

output "public_subnet" {
  description = "Public Sunet"
  value       = aws_subnet.terra-public-subnet-1.id
}
