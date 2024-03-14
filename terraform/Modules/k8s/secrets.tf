data "aws_secretsmanager_secret" "gitops_repo_cred_secret" {
  arn = "arn:aws:secretsmanager:us-east-1:644435390668:secret:${var.gitops_secret}"
}

data "aws_secretsmanager_secret_version" "gitops_repo_cred_current" {
  secret_id = data.aws_secretsmanager_secret.gitops_repo_cred_secret.id
}

data "aws_secretsmanager_secret" "db_cred_secret" {
  arn = "arn:aws:secretsmanager:us-east-1:644435390668:secret:${var.db_secret}"
}

data "aws_secretsmanager_secret_version" "db_current" {
  secret_id = data.aws_secretsmanager_secret.db_cred_secret.id
}

resource "kubernetes_secret" "gitops_repo_cred" {
  depends_on = [helm_release.argocd]
  metadata {
    name      = "foodist-gitops-repo-cred"
    namespace = "argocd"

    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }



  data = {
    name          = "foodist-gitops-repo-cred"
    type          = "git"
    url           = var.repo_url
    sshPrivateKey = data.aws_secretsmanager_secret_version.gitops_repo_cred_current.secret_string
  }
}


resource "kubernetes_namespace" "foodist" {
  metadata {
    name = "foodist"
  }
}

resource "kubernetes_secret" "foodist_secret" {
  depends_on = [kubernetes_namespace.foodist]
  
  metadata {
    name = "postgresql-secret"
    namespace = "foodist"
  }

  data = {
    "postgres-user-password"  = jsondecode(data.aws_secretsmanager_secret_version.db_current.secret_string)["postgres_user_password"]
    "postgres-admin-password" = ""
    "postgres-repl-password"  = ""
  }
}