/*
 * Required variables
 */
variable "app_name" {
  type    = string
  default = "terraform"
}

variable "app_env" {
  type    = string
  default = "testing"
}

variable "aws_zones" {
  description = "A list of zones to create subnets (max 8)"
  type        = list(string)

  default = [
    "us-east-1c",
    "us-east-1d",
    "us-east-1e",
  ]
}

variable "enable_dns_hostnames" {
  type    = bool
  default = false
}

variable "create_nat_gateway" {
  description = "Set to false to remove NAT gateway and associated route"
  type        = bool
  default     = true
}

variable "use_transit_gateway" {
  description = "Set to true to create transit gateway attachments and route traffic to a TGW."
  type        = bool
  default     = false
}

variable "private_subnet_cidr_blocks" {
  description = "The CIDR blocks for the private subnets (one per AZ, in order). There must be at least as many private CIDRs as AZs, and they must not overlap the public CIDRs."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.22.0/24", "10.0.33.0/24", "10.0.44.0/24"]
}

variable "public_subnet_cidr_blocks" {
  description = "The CIDR blocks for the public subnets (one per AZ, in order). There must be at least as many public CIDRs as AZs, and they must not overlap the private CIDRs."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24", "10.0.40.0/24"]
}

variable "transit_gateway_id" {
  description = "The id of the transit gateway to attach to. Used in conjuction with use_transit_gateway."
  type        = string
  default     = ""
}

variable "transit_gateway_default_route_table_association" {
  description = "Whether or not to associate with the default route table of the transit gateway."
  type        = bool
  default     = true
}

variable "transit_gateway_default_route_table_propagation" {
  description = "Whether or not to send propagation of this route to the default route table of the transit gateway."
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "The block of IP addresses (as a CIDR) the VPC should use"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_ipv6" {
  description = "Add an IPv6 CIDR block to the VPC and IPv6 CIDR blocks to the public and private subnets"
  type        = bool
  default     = false
}
