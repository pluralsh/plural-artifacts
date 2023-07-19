data "aws_route_table" "worker_private_subnets_route_table" {
  count     = var.enable_vpc_s3_endpoint && length(local.worker_private_subnet_ids) > 0 ? 1 : 0
  subnet_id = local.worker_private_subnet_ids[0]
}

resource "aws_vpc_endpoint" "s3" {
  count           = var.enable_vpc_s3_endpoint && length(local.worker_private_subnet_ids) > 0 ? 1 : 0
  vpc_id          = local.vpc_id
  service_name    = "com.amazonaws.${var.aws_region}.s3"
  auto_accept     = true
  route_table_ids = [data.aws_route_table.worker_private_subnets_route_table[0].id]
}