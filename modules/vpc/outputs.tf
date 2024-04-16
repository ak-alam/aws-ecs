output "outputs" {
value = {
    vpc_id = aws_vpc.vpc.id
    public_subnets = aws_subnet.public_subnets[*].id
    private_subnets = aws_subnet.private_subnets[*].id
    data_subnets = aws_subnet.data_subnets[*].id
    }
}