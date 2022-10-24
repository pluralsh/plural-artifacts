resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.vpc.vpc_id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  auto_accept = true
  route_table_ids = [module.vpc.default_route_table_id]
}