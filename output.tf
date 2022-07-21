output "ec2_private_dns" {
  value = aws_instance.example_ec2.private_dns
}

output "ec2_private_id" {
  value = aws_instance.example_ec2.private_ip
}

output "route53_fqdn" {
  value = aws_route53_record.example_ec2_record_set.fqdn
}

output "lb_dns" {
  value = aws_lb.loadbalaner.dns_name
}

output "lb_id" {
  value = aws_lb.loadbalaner.id
}

output "alb_target_group_arn" {
  value = aws_alb_target_group.ip_target_group.arn
}
