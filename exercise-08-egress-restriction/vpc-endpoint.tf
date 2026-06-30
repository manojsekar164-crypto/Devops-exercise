# Terraform Configuration to provision a DynamoDB VPC Gateway Endpoint

data "aws_vpc" "eks_vpc" {
  filter {
    name   = "tag:Name"
    values = ["eks-vpc"]
  }
}

data "aws_route_table" "private" {
  count  = 3
  vpc_id = data.aws_vpc.eks_vpc.id

  filter {
    name   = "tag:Name"
    values = ["eks-private-rt-${count.index}"]
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = data.aws_vpc.eks_vpc.id
  service_name      = "com.amazonaws.ap-south-1.dynamodb"
  vpc_endpoint_type = "Gateway"

  # Associate with EKS private route tables
  route_table_ids = data.aws_route_table.private.*.id

  tags = {
    Name        = "dynamodb-vpc-endpoint"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
