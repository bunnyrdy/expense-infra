module "vpc"  {
    #source = "../Terraform-VPC-Module"
  source = "git::https://github.com/bunnyrdy/Terraform-modules.git//VPC-Module"
    vpc_cidr  =    var.cidr
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    vpc_tags =  var.vpc_tags
    private_subnet_cidrs = var.private_subnet_cidrs
    public_subnet_cidrs = var.public_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    is_peering = true

    }

    resource "aws_db_subnet_group" "expense" {
  name       = "${var.project_name}-${var.environment}"
  subnet_ids = module.vpc.database_subnet_ids

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}"
    }
  )
}
