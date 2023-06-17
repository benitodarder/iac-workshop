locals {
  workspace_path        = "./workspaces/${terraform.workspace}/configuration.yaml"
  workspace             = file(local.workspace_path)
  settings              = yamldecode(local.workspace)
  key_suffix            = "${local.settings.environment}${local.settings.purpose}"
  key_suffix_hyphen     = "${local.settings.environment}-${local.settings.purpose}"
  key_suffix_underscore = "${local.settings.environment}_${local.settings.purpose}"
}