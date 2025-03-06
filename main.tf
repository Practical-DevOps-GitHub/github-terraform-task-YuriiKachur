# Створення гілки develop
resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
}

# Встановлення гілки develop як гілки за замовчуванням
resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch     = github_branch.develop.branch
