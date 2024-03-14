variable "eks_cluster_role_arn" {
  type        = string
  description = "Role ARN for EKS cluster"
}

variable "eks_node_role_arn" {
  type        = string
  description = "Role ARN for EKS node group"
}

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

variable subnets {
  type        = list(string) 
  description = "Ids for subnets"
}

variable "node_key_name" {
  description = "The name of the EC2 key pair to attach to the nodes"
  type        = string
  # You can set a default value or leave it without and provide the value at runtime or through a tfvars file.
  default     = "Igor-rsa-key"
}

variable "project_name" {
  description = "name of the project"
  type = string
}