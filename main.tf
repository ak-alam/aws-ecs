####################################
# VPC
####################################

module "vpc" {
  source               = "./modules/vpc" #referencing the source module
  identifier           = var.identifier
  vpc_cidr             = var.cluster_vpc.vpc_cidr
  public_subnets       = var.cluster_vpc.public_subnets
  private_subnets      = var.cluster_vpc.private_subnets
}

####################################
# ECS Cluster
####################################
module "ecs_cluster" {
  source = "./modules/ecs"
  identifier = var.identifier
  cluster_name = var.ecs_cluster_settings.cluster_name
}

####################################
# Service discovery
####################################
module "cloudmap" {
  source = "./modules/service-discovery/cloudmap"
  vpc_id = module.vpc.outputs.vpc_id
  private_domain_namespace = "weaveops"
}
module "service_discovery_main" {
 for_each = toset(var.service_discovery_name)
  source = "./modules/service-discovery"
  cloudmap_namespace_id = module.cloudmap.outputs.id
  service_discovery_name = each.value
}

#############################################
#Backend Service & it's supporting resources
#############################################
#LB security group
module "lb_sg" {
  source = "./modules/sg"
  identifier           = var.identifier
  vpc_id = module.vpc.outputs.vpc_id
  sg_name = var.public_lb_sg.sg_name
  ingress_rule_list = var.public_lb_sg.ingress_rule_list
  # egress_rule_list = var.lb_sg.egress_rule_list

  depends_on = [ module.vpc ]
}

#Public ALB Backend
# module "backend_public_alb" {
#   source = "./modules/lb"
#   identifier = var.identifier
#   lb_name = var.backend_public_alb.lb_name
#   security_groups = [module.lb_sg.outputs.security_group_id]
#   subnet_ids = module.vpc.outputs.public_subnets
#   tg_name = var.backend_public_alb.tg_name
#   tg_port = var.backend_public_alb.tg_port
#   tg_protocol = var.backend_public_alb.tg_protocol
#   target_type = var.backend_public_alb.target_type
#   vpc_id = module.vpc.outputs.vpc_id

#   depends_on = [ module.backend_service_sg, module.vpc ]
# }

#Backend service security group
module "backend_service_sg" {
  source = "./modules/sg"
  identifier           = var.identifier
  vpc_id = module.vpc.outputs.vpc_id
  sg_name = var.backend_service_sg.sg_name
  ingress_rule_list = var.backend_service_sg.ingress_rule_list
  # egress_rule_list = var.lb_sg.egress_rule_list
  depends_on = [ module.lb_sg ]
}


module "backend_service_task" {
  source = "./modules/ecs/service-task-definition"
  identifier = var.identifier
  family = var.backend_task_definition_settings.family
  requires_compatibilities = var.backend_task_definition_settings.requires_compatibilities
  container_definitions = var.backend_task_definition_settings.container_definitions

  service_cluster_name = module.ecs_cluster.outputs.ecs_cluster.name
  service_subnet_ids = module.vpc.outputs.private_subnets
  service_sg_ids = [module.backend_service_sg.outputs.security_group_id] 
  # service_target_group_arn = module.backend_public_alb.outputs.target_group.arn
  
  enable_service_registry = true
  service_discovery_name_arn = module.service_discovery_main["redis"].outputs.arn
  depends_on = [ module.vpc, module.ecs_cluster ]
}

##############################
#Web App Service
##############################

# Public ALB frontend
module "frontend_public_alb" {
  source = "./modules/lb"
  identifier = var.identifier
  lb_name = var.frontend_public_alb.lb_name
  security_groups = [module.lb_sg.outputs.security_group_id]
  subnet_ids = module.vpc.outputs.public_subnets
  tg_name = var.frontend_public_alb.tg_name
  tg_port = var.frontend_public_alb.tg_port
  tg_protocol = var.frontend_public_alb.tg_protocol
  target_type = var.frontend_public_alb.target_type
  vpc_id = module.vpc.outputs.vpc_id
}

module "webapp_service_task" {
  source = "./modules/ecs/service-task-definition"
  identifier = var.identifier
  family = var.webapp_service_task.family
  requires_compatibilities = var.webapp_service_task.requires_compatibilities
  container_definitions = var.webapp_service_task.container_definitions

  service_cluster_name = module.ecs_cluster.outputs.ecs_cluster.name
  service_subnet_ids = module.vpc.outputs.private_subnets
  service_sg_ids = [module.backend_service_sg.outputs.security_group_id]
  enable_service_loadbalancing = true
  service_target_group_arn = module.frontend_public_alb.outputs.target_group.arn
  
  # enable_service_registry = true
  # service_discovery_name_arn = module.service_discovery_main["redis"].outputs.arn
  depends_on = [ module.vpc, module.ecs_cluster, module.frontend_public_alb ]
}
