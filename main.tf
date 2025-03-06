provider "github" {
}

# Set the default branch to `develop`
resource "github_branch_default" "default" {
  branch     = "develop"
}

# Add `softservedata` as a collaborator
resource "github_repository_collaborator" "collaborator" {
  username   = "softservedata"
  permission = "push"
}

# Protect the `develop` branch
resource "github_branch_protection" "develop" {
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
