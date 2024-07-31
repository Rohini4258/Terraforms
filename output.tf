output "ec2_public_ip" {
  value       = aws_instance.new.public_ip
  description = "Print the value of public ip"
}

output "ec2_private_ip" {
  value       = aws_instance.new.private_ip
  description = "print the value of private ip"
  sensitive   = true
}