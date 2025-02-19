module "vpc_minimal" {
  source = "../aws/vpc"
}

module "vpc_all_inputs" {
  source = "../aws/vpc"

  app_name                                        = ""
  app_env                                         = ""
  aws_zones                                       = [""]
  enable_dns_hostnames                            = false
  create_nat_gateway                              = false
  use_transit_gateway                             = false
  private_subnet_cidr_blocks                      = [""]
  public_subnet_cidr_blocks                       = [""]
  transit_gateway_id                              = ""
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  vpc_cidr_block                                  = ""
  enable_ipv6                                     = true
}
