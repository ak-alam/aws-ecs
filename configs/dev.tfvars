identifier           = "primte"
#VPC
cluster_vpc = {
    vpc_cidr             = "10.0.0.0/16"
    public_subnets       = ["10.0.1.0/24", "10.0.3.0/24"]
    private_subnets      = ["10.0.2.0/24", "10.0.4.0/24"]
}
#LB SG
public_lb_sg = {
    sg_name = "public_lb_sg"
    ingress_rule_list = [
        {
            source_security_group_id = null
            cidr_blocks              = ["0.0.0.0/0"],
            description              = "Port 80 rule for Load balancer",
            from_port                = 80,
            protocol                 = "tcp",
            to_port                  = 80
        },
        {
            source_security_group_id = null
            cidr_blocks              = ["0.0.0.0/0"],
            description              = "Port 443 rule for Load balancer",
            from_port                = 443,
            protocol                 = "tcp",
            to_port                  = 443
        },

    ]
}
#Backend service security group
backend_service_sg = {
    sg_name = "backend_service_sg"
    ingress_rule_list = [
        {
            source_security_group_id = null
            cidr_blocks              = ["0.0.0.0/0"],
            description              = "All traffic",
            from_port                = 0,
            protocol                 = "-1",
            to_port                  = 0
        }]    
}




#ALB Backend
backend_public_alb = {
    lb_name = "backend"
    tg_name = "backend"
    tg_port = 80
    tg_protocol = "HTTP"
    target_type = "ip"
}



#ECS Cluster
ecs_cluster_settings={
    cluster_name = "service-discovery"
}

backend_task_definition_settings = {
    family = "redis"
    requires_compatibilities = "FARGATE"
    container_definitions = [
    {
      name = "redis"
      image = "redis:latest"
      memory = 1024
      cpu = 512
      essential = true
      container_port = 6379
      environment = {
        #   API_endpoint = "backendAPI.servicediscovery.com"
        #   CND_endpoint = "cdn.edgeservice.com"
        }
      secrets = {
        # password = "arnofvalue"
      } 
    }]


}


# ALB Frontend
frontend_public_alb = {
    lb_name = "frontend"
    tg_name = "frontend"
    tg_port = 5000
    tg_protocol = "HTTP"
    target_type = "ip"

}



webapp_service_task = {
    family = "webapp"
    requires_compatibilities = "FARGATE"
    container_definitions = [
    {
      name = "webapp"
      image = "360286454260.dkr.ecr.us-east-1.amazonaws.com/flask-web:latest"
      memory = 1024
      cpu = 512
      essential = true
      container_port = 5000
      environment = {
          REDIS_HOST = "redis.weaveops"
        }
      secrets = {
        # password = "arnofvalue"
      } 
    }]


}