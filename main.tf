provider "github" {
  token = var.github_token  # Токен для автентифікації
}

variable "repository_name" {
  description = "The name of the GitHub repository"
  type        = string
}

variable "github_token" {
  description = "GitHub Token for authentication"
  type        = string
}

resource "github_repository" "repo" {
  name           = var.repository_name
  visibility     = "private"
  default_branch = "develop"  # Встановлюємо develop як дефолтну гілку
}

resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"  # Створюємо гілку develop
}

# Вихід дефолтної гілки
output "default_branch" {
  value = github_repository.repo.default_branch  # Повертаємо значення дефолтної гілки
}

