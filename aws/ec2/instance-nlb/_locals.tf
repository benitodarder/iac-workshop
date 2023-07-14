locals {
  workspace_path = "./workspaces/${terraform.workspace}/configuration.yaml"
  workspace      = file(local.workspace_path)
  settings       = yamldecode(local.workspace)
}