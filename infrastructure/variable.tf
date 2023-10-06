
variable "environment" {
  type        = string
  default     = "beta"
  description = "AWS Environment"
}

variable "namespace" {
  type        = string
  default     = "project-heliodor"
  description = "AWS Environment"
}

locals {
  env_prefix     = "${var.namespace}-${var.environment}"
  domain_name    = "project-heliodor.com"
  auth_domain    = "dev-r4ixstm06ythgal5.us.auth0.com"
  auth_client_id = "AuTHCru9jbuWge6e9zb5OEZvswfeDW8w"
  api_url        = "api.project-heliodor.com"
  product_name   = "Bitbucket Pipeline Visualizer"
}
