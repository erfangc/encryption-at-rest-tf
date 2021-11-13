resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "esd" {

  domain_name           = "main"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type          = "r6gd.large.elasticsearch"
    instance_count         = 3
    zone_awareness_enabled = true
    zone_awareness_config {
      availability_zone_count = 3
    }
  }

  ebs_options {
    ebs_enabled = false
  }

  vpc_options {
    subnet_ids         = module.vpc.private_subnets
    security_group_ids = [
      aws_security_group.elasticsearch-domain-sg.id
    ]
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled    = true
    kms_key_id = aws_kms_key.cmk.id
  }

  access_policies = jsonencode({
    Version = "2012-10-17",
    Statement : [
      {
        Action    = "es:*",
        Principal = "*",
        Effect    = "Allow",
        Resource  = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/main/*"
      }
    ]
  })

}
