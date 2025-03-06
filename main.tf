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

# Create the `develop` branch
resource "github_branch" "develop" {
  repository = var.repository_name
  branch     = "develop"
}

# Add `softservedata` as a collaborator
resource "github_repository_collaborator" "collaborator" {
  repository = var.repository_name
  username   = "softservedata"
  permission = "push"
}
