# outputs you can kist required endpoints, ip or instanceid's

output "alb_hostname" {
  value = aws_alb.alb.dns_name
}

output "az" {
  value = data.aws_availability_zones.available.names
}
output "vpc_id" {
  value = aws_vpc.cluster-vpc.id
}
output "end_point" {
  value = aws_db_instance.adminer_rds.endpoint
}
