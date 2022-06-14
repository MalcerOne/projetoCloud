

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
#   load_config_file       = false
#   version                = "~> 1.11"
# }

# # ========== Data ==============
# data "aws_eks_cluster" "cluster" {
#   name = module.eks.cluster_id
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks.cluster_id
# }

# data "aws_availability_zones" "available" {
# }

# # ========== Modules ==============
# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "2.6.0"

#   name                    = "vpc-rafael"
#   cidr                    = "172.31.0.0/16"
#   azs                     = data.aws_availability_zones.available.names
#   private_subnets         = ["172.31.16.0/20"]
#   public_subnets          = ["172.31.64.0/20"]
#   enable_nat_gateway      = true
#   enable_dns_hostnames    = true
#   map_public_ip_on_launch = true

#   public_subnet_tags = {
#     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#     "kubernetes.io/role/elb"                    = "1"
#   }

#   private_subnet_tags = {
#     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#     "kubernetes.io/role/internal-elb"           = "1"
#   }
# }

# module "eks" {
#   source                          = "terraform-aws-modules/eks/aws"
#   cluster_name                    = var.cluster_name
#   cluster_version                 = "1.17"
#   subnets                         = module.vpc.public_subnets
#   cluster_endpoint_private_access = true
#   cluster_endpoint_public_access  = true
#   vpc_id                          = module.vpc.vpc_id


#   worker_groups = [
#     {
#       name                 = "worker-group-1"
#       instance_type        = "t2.small"
#       asg_desired_capacity = 1
#     },
#     {
#       name                 = "worker-group-2"
#       instance_type        = "t2.small"
#       asg_desired_capacity = 1
#     },
#     {
#       name                 = "worker-group-3"
#       instance_type        = "t2.small"
#       asg_desired_capacity = 1
#     },
#   ]
# }


# # resource "aws_security_group" "worker1_group" {
# #   name_prefix = "worker1_group"
# #   vpc_id      = module.vpc.vpc_id

# #   ingress {
# #     from_port = 22
# #     to_port   = 22
# #     protocol  = "tcp"

# #     cidr_blocks = [
# #       "10.0.0.0/8",
# #     ]
# #   }
# # }

# # resource "aws_security_group" "all_worker_mgmt" {
# #   name_prefix = "all_worker_management"
# #   vpc_id      = module.vpc.vpc_id

# #   ingress {
# #     from_port = 22
# #     to_port   = 22
# #     protocol  = "tcp"

# #     cidr_blocks = [
# #       "10.0.0.0/8",
# #       "172.16.0.0/12",
# #       "192.168.0.0/16",
# #     ]
# #   }
# # }

# resource "kubernetes_service" "example" {
#   metadata {
#     name = "terraform-example"
#   }
#   spec {
#     selector = {
#       test = "MyExampleApp"
#     }
#     port {
#       port        = 80
#       target_port = 80
#     }

#     type = "LoadBalancer"
#   }
# }