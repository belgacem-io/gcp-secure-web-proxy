variable "project_id" {
  type        = string
  description = "Project ID for Private Shared VPC."
}

variable "default_region" {
  type        = string
  description = "Default region 1 for subnets and Cloud Routers"
}

variable "hub_public_subnets" {
  type = list(object({
    subnet_name  = string
    subnet_ip    = string
  }))
  description = "The list of public subnets being created for HUB"
  default     = []
}

variable "hub_private_subnets" {
  type = list(object({
    subnet_name  = string
    subnet_ip    = string
  }))
  description = "The list of private subnets being created for HUB"
  default     = []
}

variable "spoke1_private_subnets" {
  type = list(object({
    subnet_name  = string
    subnet_ip    = string
  }))
  description = "The list of private subnets being created for spoke 1"
  default     = []
}