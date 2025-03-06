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

resource "github_repository_collaborator" "collaborator" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push"  # Adjust permissions as needed
}

resource "github_branch_protection" "develop_protection" {
  repository = github_repository.repo.name
  branch     = "develop"
  required_pull_request_reviews {
    required_approving_review_count = 2
  }
}
