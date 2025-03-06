provider "github" {
  token = var.github_token  # GitHub Token for authentication
}

variable "github_token" {
  description = "GitHub Token"
  type        = string
}

variable "repository_name" {
  description = "The name of the GitHub repository"
  type        = string
}

# Create a new repository with default branch set to 'develop'
resource "github_repository" "repo" {
  name           = var.repository_name
  visibility     = "private"
  default_branch = "develop"  # Set the default branch to 'develop'
}

# Create the 'develop' branch if it doesn't already exist
resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"  # Create the 'develop' branch
}

# Add collaborator 'softservedata' with 'push' permission
resource "github_repository_collaborator" "collaborator" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push"  # Adjust permission as needed
}

# Protect 'develop' branch (with 2 required reviews)
resource "github_branch_protection" "develop_protection" {
  repository = github_repository.repo.name
  branch     = "develop"
  required_pull_request_reviews {
    required_approving_review_count = 2
  }
}

# Protect 'main' branch (require code owner reviews)
resource "github_branch_protection" "main_protection" {
  repository = github_repository.repo.name
  branch     = "main"
  required_pull_request_reviews {
    require_code_owner_reviews = true
  }
}

# Add GitHub Actions secret 'PAT'
resource "github_actions_secret" "PAT" {
  repository    = github_repository.repo.name
  secret_name   = "PAT"
  plaintext_value = var.pat_value  # The value for the secret
}

# Add a deploy key to the repository
resource "github_repository_deploy_key" "deploy_key" {
  repository = github_repository.repo.name
  title      = "DEPLOY_KEY"
  key        = var.deploy_key  # The deploy key value
  read_only  = true  # Set to 'true' for read-only access
}

# Outputs to check the configurations
output "default_branch" {
  value = github_repository.repo.default_branch
}

output "collaborator" {
  value = github_repository_collaborator.collaborator.username
}

output "develop_protection" {
  value = github_branch_protection.develop_protection.branch
}

output "main_protection" {
  value = github_branch_protection.main_protection.branch
}

output "actions_secret" {
  value = github_actions_secret.PAT.secret_name
}

output "deploy_key" {
  value = github_repository_deploy_key.deploy_key.title
}
