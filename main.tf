# Оголошення змінних
variable "github_token" {
  description = "GitHub token for authentication"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub owner (username or organization)"
  type        = string
}

variable "repository_name" {
  description = "Name of the GitHub repository"
  type        = string
}

# Налаштування провайдера GitHub
provider "github" {
  token = var.github_token
  owner = var.github_owner
}

# Створення репозиторію
resource "github_repository" "repo" {
  name               = var.repository_name
  description        = "Terraform managed repository"
  visibility         = "private"
  auto_init          = true
  license_template   = "mit"
  gitignore_template = "Terraform"
}

# Створення гілки develop
resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
}

# Встановлення гілки develop як гілки за замовчуванням
resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch     = github_branch.develop.branch
}

# Додавання користувача softservedata як співавтора
resource "github_repository_collaborator" "collaborator" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push"
}

# Збереження Terraform коду у секреті репозиторію
resource "github_actions_secret" "terraform" {
  repository      = github_repository.repo.name
  secret_name     = "TERRAFORM"
  plaintext_value = file("main.tf")
}
