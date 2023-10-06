# resource "aws_docdb_subnet_group" "docdb_subnet" {
#   name       = "${local.env_prefix}-docdb-subnet"
#   subnet_ids = aws_subnet.public.*.id
# }

# resource "aws_security_group" "docdb_security_group" {
#   name   = "${local.env_prefix}-sg-docdb"
#   vpc_id = aws_vpc.main.id

#   ingress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     # Only allowing traffic in from the ecs tasks and vpn security groups
#     security_groups = [aws_security_group.ecs_tasks.id]
#   }

#   egress {
#     protocol         = "-1"
#     from_port        = 0
#     to_port          = 0
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_docdb_cluster_instance" "instance" {
#   count              = 1
#   identifier         = "${local.env_prefix}-instance-${count.index}"
#   cluster_identifier = aws_docdb_cluster.cluster.id
#   instance_class     = "db.r6g.large"
# }

# resource "aws_docdb_cluster" "cluster" {
#   skip_final_snapshot             = true
#   db_subnet_group_name            = aws_docdb_subnet_group.docdb_subnet.name
#   cluster_identifier              = "${local.env_prefix}-cluster"
#   engine                          = "docdb"
#   master_username                 = "tf_${replace(local.env_prefix, "-", "_")}_admin"
#   master_password                 = "abc123DEF"
#   db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.param_group.name
#   vpc_security_group_ids          = [aws_security_group.docdb_security_group.id]
# }

# resource "aws_docdb_cluster_parameter_group" "param_group" {
#   family = "docdb4.0"
#   name   = "${local.env_prefix}-param-group"

#   parameter {
#     name  = "tls"
#     value = "disabled"
#   }
# }


# output "docdb_endpoint" {
#   value = aws_docdb_cluster.cluster.endpoint
# }

# output "docdb_username" {
#   value = aws_docdb_cluster.cluster.master_username
# }
