module "network" {

  source       = "./Modules/network"
  all_Traffic  = var.all_Traffic
  cidr_offset  = var.cidr_offset
  Subnet_Count = var.Subnet_Count
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  public_subnet_tags = {
    "kubernetese.io/role/alb" = 1
  }
  private_subnet_tags = {
    "kubernetese.io/role/internal-elb" = 1
  }
}

module "security" {
  source = "./Modules/security"

}

module "eks" {
  source     = "./Modules/eks"
  depends_on = [module.security]

  eks_cluster_role_arn = module.security.eks_cluster_role_arn
  eks_node_role_arn    = module.security.eks_node_role_arn

  node_group_instance_type = var.node_group_instance_type
  node_group_desired_size  = var.node_group_desired_size
  node_group_max_size      = var.node_group_max_size
  node_group_min_size      = var.node_group_min_size
  project_name             = var.project_name
  subnets                  = module.network.subnets
}

module "k8s" {
  source     = "./modules/k8s"
  depends_on = [module.eks]

  count = var.apply_k8s_module ? 1 : 0

  chart_path    = "${path.module}/charts/argo-cd-5.52.1.tgz"
  repo_url      = var.repo_url
  values_path   = "${path.module}/manifests/argocd.yaml"
  main_cd_path  = "${path.module}/manifests/Main-cd.yaml"
  project_name  = var.project_name
  gitops_secret = var.gitops_secret
  db_secret     = var.db_secret


}
