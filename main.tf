provider "github" {
  token = var.github_token
  owner = var.github_owner
}

resource "github_repository" "repo" {
  name               = var.repository_name
  description        = "Terraform managed repository"
  visibility         = "private"
  auto_init          = true
  license_template   = "mit"
  gitignore_template = "Terraform"
}

resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
}

resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch     = github_branch.develop.branch
}


resource "github_repository_file" "pull_request_template" {
  repository          = github_repository.repo.name
  branch              = github_branch.develop.branch
  file                = ".github/pull_request_template.md"
  content             = file("pull_request_template.md")
  commit_message      = "Add pull request template"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_actions_secret" "pat" {
  repository      = github_repository.repo.name
  secret_name     = "PAT"
  plaintext_value = var.pat
}

resource "github_actions_secret" "terraform" {
  repository      = github_repository.repo.name
  secret_name     = "TERRAFORM"
  plaintext_value = file("main.tf")
}

resource "github_repository_deploy_key" "deploy_key" {
  title      = "DEPLOY_KEY"
  repository = github_repository.repo.name
  key        = var.deploy_key
  read_only  = false
}
