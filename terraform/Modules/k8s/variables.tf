variable values_path {
  type        = string
  description = "Path to ArgoCD values.yml"
}

variable main_cd_path {
  type        = string
  description = "Path to bootsrap application resource manifest"
}

variable chart_path {
  type        = string
  description = "Path to argo cd chart"
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