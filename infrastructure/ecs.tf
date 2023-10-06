# locals {
#   cidr               = "10.0.0.0/16"
#   private_subnets    = ["10.0.0.0/24", "10.0.1.0/24"]
#   public_subnets     = ["10.0.100.0/24", "10.0.101.0/24"]
#   availability_zones = ["us-east-1a", "us-east-1b"]
#   container_port     = 3000
#   health_check_path  = "/health"
#   alb_tls_cert_arn   = ""
# }

# resource "aws_vpc" "main" {
#   cidr_block = local.cidr
# }

# resource "aws_internet_gateway" "main" {
#   vpc_id = aws_vpc.main.id
# }

# resource "aws_subnet" "private" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = element(local.private_subnets, count.index)
#   availability_zone = element(local.availability_zones, count.index)
#   count             = length(local.private_subnets)
# }

# resource "aws_subnet" "public" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = element(local.public_subnets, count.index)
#   availability_zone       = element(local.availability_zones, count.index)
#   count                   = length(local.public_subnets)
#   map_public_ip_on_launch = true
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id
# }

# resource "aws_route" "public" {
#   route_table_id         = aws_route_table.public.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.main.id
# }

# resource "aws_route_table_association" "public" {
#   count          = length(local.public_subnets)
#   subnet_id      = element(aws_subnet.public.*.id, count.index)
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_nat_gateway" "main" {
#   count         = length(local.private_subnets)
#   allocation_id = element(aws_eip.nat.*.id, count.index)
#   subnet_id     = element(aws_subnet.public.*.id, count.index)
#   depends_on    = [aws_internet_gateway.main]
# }

# resource "aws_eip" "nat" {
#   count = length(local.private_subnets)
#   vpc   = true
# }

# resource "aws_route_table" "private" {
#   count  = length(local.private_subnets)
#   vpc_id = aws_vpc.main.id
# }

# resource "aws_route" "private" {
#   count                  = length(compact(local.private_subnets))
#   route_table_id         = element(aws_route_table.private.*.id, count.index)
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
# }

# resource "aws_route_table_association" "private" {
#   count          = length(local.private_subnets)
#   subnet_id      = element(aws_subnet.private.*.id, count.index)
#   route_table_id = element(aws_route_table.private.*.id, count.index)
# }

# resource "aws_security_group" "alb" {
#   name   = "${local.env_prefix}-sg-alb"
#   vpc_id = aws_vpc.main.id

#   ingress {
#     protocol         = "tcp"
#     from_port        = 80
#     to_port          = 80
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     protocol         = "tcp"
#     from_port        = 443
#     to_port          = 443
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     protocol         = "-1"
#     from_port        = 0
#     to_port          = 0
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_security_group" "ecs_tasks" {
#   name   = "${local.env_prefix}-sg-task"
#   vpc_id = aws_vpc.main.id

#   ingress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     # Only allowing traffic in from the load balancer security group
#     security_groups = [aws_security_group.alb.id]
#   }

#   egress {
#     protocol         = "-1"
#     from_port        = 0
#     to_port          = 0
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_ecs_cluster" "services_cluster" {
#   name = "${local.env_prefix}-services"
# }

# # pipeline-api service
# resource "aws_ecs_service" "api_service" {
#   name                = "pipeline-api-service"
#   cluster             = aws_ecs_cluster.services_cluster.id
#   task_definition     = aws_ecs_task_definition.api_task.arn
#   desired_count       = 1
#   launch_type         = "FARGATE"
#   scheduling_strategy = "REPLICA"

#   network_configuration {
#     security_groups  = [aws_security_group.ecs_tasks.id]
#     subnets          = aws_subnet.public.*.id
#     assign_public_ip = true
#   }
#   load_balancer {
#     target_group_arn = aws_alb_target_group.services_target_group.arn
#     container_name   = "${local.env_prefix}-pipeline-api-container"
#     container_port   = local.container_port
#   }

#   depends_on = [
#     aws_alb_target_group.services_target_group,
#     aws_ecs_task_definition.api_task
#   ]

#   lifecycle {
#     ignore_changes = [desired_count]
#   }
# }

# resource "aws_ecs_task_definition" "api_task" {
#   family                   = "service"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = 1024
#   memory                   = 2048

#   execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn      = aws_iam_role.ecs_task_role.arn

#   container_definitions = jsonencode([
#     {
#       name      = "${local.env_prefix}-pipeline-api-container"
#       image     = "840916924042.dkr.ecr.us-east-1.amazonaws.com/project-heliodor-beta-ecr:pipeline-api-latest"
#       essential = true
#       portMappings = [
#         {
#           protocol      = "tcp"
#           containerPort = local.container_port
#           hostPort      = local.container_port
#         }
#       ]
#       environment = [
#         { name : "TEST_ENVIRONMENT_VARIABLE", value : "here" },
#         { name : "MONGODB_CONNECTION_STRING", value : "mongodb://${aws_docdb_cluster.cluster.endpoint}:27017/pipelines?authSource=admin&retryWrites=false" },
#         { name : "BITBUCKET_TOKEN", value : "ATCTT3xFfGN0l6BUTE-0g9JzEQ4naHNsV-9svVmsHUHFvuSyc--qSH_v01-f919U-6CsbwVu_PpO8AUvLopbFUSrTjJyo1DKgJmIrNl7eCWEUincmW42WQFaU2Fjx3OkWc2EijX1L-J1EIbCmteJWDt6niYMh1GyzSEs8LiOKgzhSJ-v34lp9vY=1468555C" }
#       ]
#       logConfiguration = {
#         logDriver = "awslogs"

#         options = {
#           awslogs-group         = "pipeline-api-task"
#           awslogs-region        = "us-east-1"
#           awslogs-create-group  = "true"
#           awslogs-stream-prefix = "ecs"
#         }
#       }
#     }
#   ])

#   runtime_platform {
#     cpu_architecture = "ARM64"
#   }
# }

# resource "aws_iam_role" "ecs_task_role" {
#   name = "${local.env_prefix}-ecsTaskRole2"

#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "ecs-tasks.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
# }
# EOF
# }

# resource "aws_iam_role" "ecs_task_execution_role" {
#   name = "${local.env_prefix}-ecsTaskExecutionRole"

#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "ecs-tasks.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }
# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_logging_policy_attachment" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = aws_iam_policy.ecs_logging.arn
# }

# resource "aws_iam_policy" "ecs_logging" {
#   name        = "ecs_logging"
#   path        = "/"
#   description = "IAM policy for logging from a ecs"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ],
#       "Resource": "arn:aws:logs:*:*:*",
#       "Effect": "Allow"
#     }
#   ]
# }
# EOF
# }

# resource "aws_lb" "main" {
#   name               = "${local.env_prefix}-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb.id]
#   subnets            = aws_subnet.public.*.id

#   enable_deletion_protection = false
# }

# resource "aws_alb_target_group" "services_target_group" {
#   name        = "${local.env_prefix}-tg"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.main.id
#   target_type = "ip"

#   health_check {
#     healthy_threshold   = "3"
#     interval            = "30"
#     protocol            = "HTTP"
#     matcher             = "200"
#     timeout             = "3"
#     path                = local.health_check_path
#     unhealthy_threshold = "2"
#   }
# }


# resource "aws_alb_listener" "http" {
#   load_balancer_arn = aws_lb.main.id
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_alb_target_group.services_target_group.id
#     type             = "forward"
#   }

#   # default_action {
#   #  type = "redirect"

#   #  redirect {
#   #    port        = 443
#   #    protocol    = "HTTPS"
#   #    status_code = "HTTP_301"
#   #  }
#   # }
# }

# output "lb_dnsname" {
#   value = aws_lb.main.dns_name
# }

# output "vpc_id" {
#   value = aws_vpc.main.id
# }

# # resource "aws_alb_listener" "https" {
# #   load_balancer_arn = aws_lb.main.id
# #   port              = 443
# #   protocol          = "HTTPS"

# #   ssl_policy        = "ELBSecurityPolicy-2016-08"
# #   certificate_arn   = local.alb_tls_cert_arn

# #   default_action {
# #     target_group_arn = aws_alb_target_group.services_target_group.id
# #     type             = "forward"
# #   }
# # }
