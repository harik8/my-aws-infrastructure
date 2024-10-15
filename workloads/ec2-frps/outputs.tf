output "ec2_public_dns" {
  value = aws_instance.frp.public_dns
}