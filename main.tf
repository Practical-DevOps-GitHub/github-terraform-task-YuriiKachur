provider "github" {
  token = var.github_token
}

variable "repository_name" {
  description = "The name of the GitHub repository"
  type        = string
}

resource "github_repository" "repo" {
  name           = var.repository_name
  visibility     = "private"
  default_branch = "develop"
}

resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
}

resource "github_repository_collaborator" "collaborator" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push"
}

variable "github_token" {
  description = "GitHub Token"
  type        = string
}
