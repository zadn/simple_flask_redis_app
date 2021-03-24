variable "aws_default_region" {
  description = "Region where the Terraform script is to be deployed"
  type        = string
  default     = "ap-south-1"
}

/* ------------------------------------- */
/*       GitHub Provider Variables       */
/* ------------------------------------- */

variable "github_personal_access_token" {
  description = "Personal Access Token for GitHub account. You can create a new one in GitHub > Profile > Settings > Developer Settings > Personal access tokens"
  type        = string
  default     = "" # REDACTED
}

variable "github_owner_username" {
  description = "Email Address for logging into GitHub account"
  type        = string
  default     = "zadn" # Add your daimler email ID here
}

variable "github_repository" {
  description = "Repository name for the github repo"
  type        = string
  default     = "simple_flask_redis_app" # Add your daimler email ID here
}


/* ------------------------------------- */
/*       CodeBuild Variables             */
/* ------------------------------------- */

variable "codebuild_project_name" {
  description = "Project name for CodeBuild"
  type        = string
  default     = "test-build"
}

variable "codebuild_role_name" {
  description = "IAM Role name for Codebuild"
  type        = string
  default     = "codebuild-web-app-service-role"
}


/* ------------------------------------- */
/*             ECR Variables             */
/* ------------------------------------- */

variable "ecr_repository_name" {
  description = "Repository name for AWS ECR"
  type        = string
  default     = "web-app"
}

/* ------------------------------------- */
/*             EKS Variables             */
/* ------------------------------------- */

variable "eks_cluster_name" {
  description = "Cluster name for AWS EKS Cluster"
  type        = string
  default     = "my-eks-cluster"
}
