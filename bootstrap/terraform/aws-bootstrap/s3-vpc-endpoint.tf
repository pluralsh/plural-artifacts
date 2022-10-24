data "aws_route_table" "worker_private_subnets_route_table" {
  subnet_id = module.vpc.worker_private_subnets_ids[0]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.vpc.vpc_id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  auto_accept = true
  route_table_ids = [data.aws_route_table.worker_private_subnets_route_table.id]
}