provider "github" {
  owner = var.github_organization
}

resource "github_branch_default" "develop" {
  repository = "example"
  branch     = "develop"
}
