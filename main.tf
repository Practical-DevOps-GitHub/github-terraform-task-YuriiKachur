provider "github" {
  token = var.github_token
}

variable "github_token" {}
variable "repo_name" { default = "your-repository-name" }
variable "deploy_key_path" { default = "~/.ssh/id_rsa.pub" }
variable "discord_webhook_url" {}

resource "github_repository" "repo" {
  name        = var.repo_name
  description = "Repository managed by Terraform"
  visibility  = "private"
  auto_init   = true
  has_issues  = true
  has_projects = true
  has_wiki    = true
}

resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
  depends_on = [github_repository.repo]
}

resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch     = github_branch.develop.branch
  depends_on = [github_branch.develop]
}

resource "github_repository_collaborator" "collaborator" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push"
}

resource "github_branch_protection" "develop_protection" {
  repository = github_repository.repo.name
  branch     = github_branch.develop.branch
  required_status_checks {
    strict   = true
    contexts = []
  }
  required_pull_request_reviews {
    required_approving_review_count = 2
  }
  restrictions {}
  depends_on = [github_branch.develop]
}

resource "github_branch_protection" "main_protection" {
  repository = github_repository.repo.name
  branch     = "main"
  required_status_checks {
    strict   = true
    contexts = []
  }
  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews = true
  }
  restrictions {
    users = ["your-github-username"]
  }
}

resource "github_repository_file" "codeowners" {
  repository          = github_repository.repo.name
  file               = ".github/CODEOWNERS"
  content            = "* @softservedata"
  commit_message     = "Add CODEOWNERS file"
  overwrite_on_create = true
  depends_on         = [github_branch.main_protection]  # CODEOWNERS тільки для main
}

resource "github_repository_file" "pr_template" {
  repository          = github_repository.repo.name
  file               = ".github/pull_request_template.md"
  content            = <<EOT
## Describe your changes

## Issue ticket number and link

## Checklist before requesting a review
- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update
EOT
  commit_message     = "Add Pull Request template"
  overwrite_on_create = true
  depends_on         = [github_branch.develop_protection]
}

resource "github_repository_deploy_key" "deploy_key" {
  repository = github_repository.repo.name
  title      = "DEPLOY_KEY"
  key        = file(var.deploy_key_path)
  read_only  = false
  depends_on = [github_repository.repo]
}

resource "github_actions_secret" "discord_webhook" {
  repository    = github_repository.repo.name
  secret_name   = "DISCORD_WEBHOOK"
  plaintext_value = var.discord_webhook_url
  depends_on    = [github_repository.repo]
}

resource "github_actions_secret" "pat" {
  repository    = github_repository.repo.name
  secret_name   = "PAT"
  plaintext_value = var.github_token
  depends_on    = [github_repository.repo]
}
