
# Set the default branch to `develop`
resource "github_branch_default" "default" {
  branch     = "develop"
}

# Create the `develop` branch
resource "github_branch" "develop" {
  branch     = "develop"
}

# Add `softservedata` as a collaborator
resource "github_repository_collaborator" "collaborator" {
  username   = "softservedata"
  permission = "push"
}

# Protect the `develop` branch
resource "github_branch_protection" "develop" {
  repository_id = github_repository.repo.name
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
  repository_id = github_repository.repo.name
  pattern       = "main"

  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
  }

  enforce_admins = true
}

# Add `softservedata` as a code owner for all files in the `main` branch
resource "github_repository_file" "codeowners" {
  repository = github_repository.repo.name
  branch     = "main"
  file       = ".github/CODEOWNERS"
  content    = "* @softservedata"
  commit_message = "Add CODEOWNERS file"
}

# Add a pull request template
resource "github_repository_file" "pr_template" {
  repository = github_repository.repo.name
  branch     = "main"
  file       = ".github/pull_request_template.md"
  content    = <<EOT
### Describe your changes

### Issue ticket number and link

### Checklist before requesting a review
- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update
EOT
  commit_message = "Add pull request template"
}

# Add a deploy key
resource "github_repository_deploy_key" "deploy_key" {
  repository = github_repository.repo.name
  title      = "DEPLOY_KEY"
  key        = var.deploy_key
  read_only  = false
}

# Create a PAT and add it to GitHub Actions secrets
resource "github_actions_secret" "pat" {
  repository      = github_repository.repo.name
  secret_name     = "PAT"
  plaintext_value = var.github_pat
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
