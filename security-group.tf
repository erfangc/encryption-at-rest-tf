resource "aws_security_group" "elasticsearch-domain-sg" {
  name = "elasticsearch"
  description = "Elasticsearch domain security group"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "elasticsearch-allow-https" {
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.elasticsearch-domain-sg.id
  cidr_blocks = [
    module.vpc.vpc_cidr_block
  ]
  type = "ingress"
}
