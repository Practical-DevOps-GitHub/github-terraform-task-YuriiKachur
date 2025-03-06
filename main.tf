provider "github" {
  token = var.github_token
  owner = var.github_owner
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub organization or user"
  type        = string
}

variable "repository_name" {
  description = "Name of the existing GitHub repository"
  type        = string
}

# Set the default branch to `develop`
resource "github_branch_default" "default" {
  repository = var.repository_name
  branch     = "develop"
}

# Add `softservedata` as a collaborator
resource "github_repository_collaborator" "collaborator" {
  repository = var.repository_name
  username   = "softservedata"
  permission = "push"
}

# Protect the `develop` branch
resource "github_branch_protection" "develop" {
  repository_id = var.repository_name
  pattern       = "develop"

  required_pull_request_reviews {
    required_approving_review_count = 2
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = false
  }

  enforce_admins = true
}

# Protect the `main` branch
resource "github_branch_protection" "main" {
  repository_id = var.repository_name
  pattern       = "main"

  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
  }

  enforce_admins = true
}

# Add a GitHub Actions secret
resource "github_actions_secret" "pat" {
  repository      = var.repository_name
  secret_name     = "PAT"
  plaintext_value = var.github_pat
}

# Add a deploy key
resource "github_repository_deploy_key" "deploy_key" {
  repository = var.repository_name
  title      = "DEPLOY_KEY"
  key        = var.deploy_key
  read_only  = false
}

# Variables for sensitive data
variable "deploy_key" {
  description = "Deploy key for the repository"
  type        = string
  sensitive   = true
}

variable "github_pat" {
  description = "GitHub Personal Access Token for Actions"
  type        = string
  sensitive   = true
}
