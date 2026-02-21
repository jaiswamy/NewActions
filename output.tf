output "ec2_instace_id" {
    value = aws_instance.actions.id
}

output "ec2_public_ip" {
    value = aws_instance.actions.public_ip
}