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