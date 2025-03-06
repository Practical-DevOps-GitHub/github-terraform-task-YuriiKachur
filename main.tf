resource "github_branch_default" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"  # Створення гілки develop
}

output "default_branch" {
  value = github_repository.repo.default_branch  # Повертаємо дефолтну гілку
}
