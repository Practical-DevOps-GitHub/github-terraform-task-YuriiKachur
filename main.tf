provider "github" {
  token = var.github_token
  owner = var.github_owner
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub organization or user"
  type        = string
}

variable "repository_name" {
  description = "Name of the existing GitHub repository"
  type        = string
}

# Create the `develop` branch using local-exec
resource "null_resource" "create_develop_branch" {
  provisioner "local-exec" {
    command = <<EOT
      git clone https://${var.github_token}@github.com/${var.github_owner}/${var.repository_name}.git
      cd ${var.repository_name}
      git checkout -b develop
      git push origin develop
    EOT
  }
}

# Set the default branch to `develop`
resource "github_branch_default" "default" {
  repository = var.repository_name
  branch     = "develop"
}

# Add `softservedata` as a collaborator
resource "github_repository_collaborator" "collaborator" {
  repository = var.repository_name
  username   = "softservedata"
  permission = "push"
}
