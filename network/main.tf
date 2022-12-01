module "vpc" {
  source = "../modules/vpc/"
  #once cloudwatch is stoodup we need to create an endpoint for it
  #probably good job to add enpoints to multiple things, like how greg explained
  name = "cirk-${var.environment}-vpc"
  cidr = "10.20.0.0/16"
  enable_dns_hostnames  = true
  enable_dns_support    = true
  enable_nat_gateway    = true
  instance_tenancy      = "default"
  azs                   = ["${var.region}b", "${var.region}c",]
  private_subnets       = ["10.20.10.0/24", "10.20.11.0/24",]
  public_subnets        = ["10.20.100.0/24", "10.20.101.0/24",]
  #connected via rds module:          database_subnets    = ["10.20.11.0/24", "10.20.10.0/24",]
  #connected vida elasticache module: elasticache_subnets = ["10.20.100.0/24",]
  #connected via redshift module:      redshift_subnets    = ["10.20.100.0/24", "10.20.101.0/24",]
  #created via elasticashe module:  create_elasticache_subnet_group = false
  #created via redshift module:     create_redshift_subnet_group    = false
  #create via redshift module:      enable_public_redshift          = true
  #created via rds module:          create_database_subnet_group    = false
  create_igw = true
  single_nat_gateway = false
  one_nat_gateway_per_az = false
  default_network_acl_name = "cirk-${var.environment}-acl"
  manage_default_network_acl = true
  default_network_acl_egress = [
    {
    "action": "allow",
    "cidr_block": "0.0.0.0/0",
    "from_port": 0,
    "icmp_code": 0,
    "icmp_type": 0,
    "protocol": "-1",
    "rule_no": 100,
    "to_port": 0
  },
  ]
  default_network_acl_ingress = [
    {
      "action": "allow",
      "cidr_block": "0.0.0.0/0",
      "from_port": 0,
      "icmp_code": 0,
      "icmp_type": 0,
      "protocol": "-1",
      "rule_no": 100,
      "to_port": 0
    },
  ]

  private_subnet_names     = ["cirk-${var.environment}-privsubnet-AZ1", "cirk-${var.environment}-privsubnet-AZ2"]
  public_subnet_names      = ["cirk-${var.environment}-pubsubnet-AZ1", "cirk-${var.environment}-pubsubnet-AZ1"]
  #created via rds module: database_subnet_names    = ["cirk-subnet-group",]
  #created via elasticache module: elasticache_subnet_names = ["gen2-redis-subnet",]
  #created via redshift module: redshift_subnet_names    = ["redshift-public-subnet-group",]
  manage_default_route_table = true
  manage_default_security_group = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "ec2.internal"

}

resource "aws_vpc_peering_connection" "market" {
  peer_owner_id = "713044078609"
  #peer_region   = "us-east-1"
  peer_vpc_id   = "vpc-2b11f152"
  auto_accept   = true
  provider= aws.market

  requester {
    #allow_classic_link_to_remote_vpc = "false"
    allow_remote_vpc_dns_resolution  = "false"
    #allow_vpc_to_remote_classic_link = "false"
  }

  tags = {
    Name = "cirk-${var.environment}-to-ckmarketing"
  }

  tags_all = {
    Name = "cirk-${var.environment}-to-ckmarketing"
  }
  vpc_id = module.vpc.vpc_id

  depends_on = [module.vpc]
}

