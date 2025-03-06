provider "github" {
  token = var.github_token
}

variable "repository_name" {
  description = "The name of the GitHub repository"
  type        = string
}

variable "github_token" {
  description = "GitHub Token for authentication"
  type        = string
}

variable "pat_value" {
  description = "The value for the GitHub Actions secret"
  type        = string
}

variable "deploy_key" {
  description = "The deploy key for the repository"
  type        = string
}

# Створюємо репозиторій з дефолтною гілкою "develop"
resource "github_repository" "repo" {
  name           = var.repository_name
  visibility     = "private"
  default_branch = "develop"  # Встановлюємо develop як дефолтну гілку
}

# Створюємо гілку "develop"
resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
}

# Додаємо колаборатора
resource "github_repository_collaborator" "collaborator" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push"  # Задаємо права доступу
}

# Налаштовуємо захист гілки "develop"
resource "github_branch_protection" "develop_protection" {
  repository = github_repository.repo.name
  branch     = "develop"
  required_pull_request_reviews {
    required_approving_review_count = 2
  }
}

# Налаштовуємо захист гілки "main"
resource "github_branch_protection" "main_protection" {
  repository = github_repository.repo.name
  branch     = "main"
  required_pull_request_reviews {
    require_code_owner_reviews = true
  }
}

# Додаємо GitHub Actions секрет
resource "github_actions_secret" "PAT" {
  repository    = github_repository.repo.name
  secret_name   = "PAT"
  plaintext_value = var.pat_value
}

# Додаємо deploy key
resource "github_repository_deploy_key" "deploy_key" {
  repository = github_repository.repo.name
  title      = "DEPLOY_KEY"
  key        = var.deploy_key
  read_only  = true  # Тільки для читання
}

# Вихідні значення для перевірки
output "default_branch" {
  value = github_repository.repo.default_branch
}

output "collaborator_username" {
  value = github_repository_collaborator.collaborator.username
}

output "develop_protection" {
  value = github_branch_protection.develop_protection.branch
}

output "main_protection" {
  value = github_branch_protection.main_protection.branch
}

output "actions_secret_name" {
  value = github_actions_secret.PAT.secret_name
}

output "deploy_key_title" {
  value = github_repository_deploy_key.deploy_key.title
}
