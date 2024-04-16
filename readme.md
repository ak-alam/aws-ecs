VPC (public, private subnets, Route Table(public+private), NAT, IGW) -> Complete
Load balancer, target group, security groups(frontend, backend) -> Half complete
ECS(Cluster, service, task defintion, cloud watch log group, Autoscaling) Fargate not EC2
ECS Service discovery (backend)




## ECS

#### Resources Created by the module.
* VPC
* Security Group
* Loadbalancer
* ECS
* Cloudmap (private DNS)

#### How To Run The Project

```bash

#Initialize project
terraform init

#Create a environment specific workspace for example dev
terraform workspace new dev

#Validate 
terraform validate

#Plan 
terraform plan --var-file=./configs/dev.tfvars

#Apply
terraform apply --var-file=./configs/dev.tfvars

```