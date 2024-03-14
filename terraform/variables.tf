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
  default     = 2
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


#EKS module:
variable "node_group_ami_type" {
  type        = string
  default     = "AL2_x86_64"
  description = "AMI associated with the EKS node group"
}

variable "node_group_disk_size" {
  type        = number
  default     = 20
  description = "Disk size in GiB for worker nodes"
}

variable "node_group_instance_type" {
  type        = string
  default     = "t3a.medium"
  description = "Instance type for the EKS node group"
}

variable "node_group_desired_size" {
  type        = number
  default     = 3
  description = "Desired size in scaling configuration for EKS node group"
}

variable "node_group_max_size" {
  type        = number
  default     = 3
  description = "Max size in scaling configuration for EKS node group"
}

variable "node_group_min_size" {
  type        = number
  default     = 3
  description = "Min size in scaling configuration for EKS node group"
}

variable "node_group_max_unavailable" {
  type        = number
  default     = 1
  description = "Max unavailable in update configuration for EKS node group"
}

variable apply_k8s_module {
  type        = bool
  default     = true
  description = "Conditionally apply K8s in the cluster"
}


variable "repo_url" {
  description = "GitOps repo url"
  type = string
}

variable "project_name" {
  description = "name of the project"
  type = string
}

variable "gitops_secret" {
  description = "name of the gitops secret"
  type = string
}

variable "db_secret" {
  description = "name of the gitops secret"
  type = string
}