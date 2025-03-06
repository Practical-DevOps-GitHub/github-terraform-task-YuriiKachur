provider "github" {
  token = var.github_token
}

resource 'github_branch_default' {
  branch     = 'develop'
}
