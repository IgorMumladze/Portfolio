variable "common_tags" {
  default = {
    owner           = "igorm"
    bootcamp        = "19"
    expiration_date = "01-01-2028"
  }
}

#Network

variable "all_Traffic" {
  description = "Allow all traffic from the internet"
  type        = string
}

variable "Subnet_Count" {
  description = "amount of instances"
  type        = number
  default     = 1
}

variable "subnet_cidr" {
  description = "subnet cidr block"
  type        = list(any)
  default     = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "vpc_cidr" {
  description = "cidr block of the vpc"
  type        = string
}

variable "cidr_offset" {
  description = "offest for subnet mask"
  type = number
}

variable "public_subnet_tags" {
  description = "Tags for public subnets"
  type        = map(string)
  default = {
    "kubernetese.io/role/alb" = "1"
  }
}

variable "private_subnet_tags" {
  description = "Tags for private subnets"
  type        = map(string)
  default = {
    "kubernetese.io/role/internal-elb" = "1"
  }
}

variable "project_name" {
  description = "name of the project"
  type = string
}