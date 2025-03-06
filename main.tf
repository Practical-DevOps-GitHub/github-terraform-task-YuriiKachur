provider "github" {
  token = var.github_token
}

resource "github_branch_default" "default_branch" {
  repository = var.repository_name
  branch     = "develop"
}
