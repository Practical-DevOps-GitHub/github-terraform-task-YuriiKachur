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
