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
  description = "Name of the GitHub repository"
  type        = string
  default     = "example-repo"
}

# Create the repository
resource "github_repository" "repo" {
  name               = var.repository_name
  description        = "Example repository with Terraform"
  visibility         = "private"
  auto_init          = true
}

# Set the default branch to `develop`
resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch     = "develop"
}

# Create the `develop` branch
resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
}

# Add `softservedata` as a collaborator
resource "github_repository_collaborator" "collaborator" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push"
}
