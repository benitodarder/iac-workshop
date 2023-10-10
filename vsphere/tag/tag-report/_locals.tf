locals {
  workspace_path = "./workspaces/${terraform.workspace}/configuration.yaml"
  workspace      = file(local.workspace_path)
  settings       = yamldecode(local.workspace)
}

data "vsphere_tag_category" "this" {
  count = length(try(local.settings.tags_map, {}))
  name  = keys(local.settings.tags_map)[count.index]
}

data "vsphere_tag" "this" {
  count       = length(try(local.settings.tags_map, {}))
  name        = local.settings.tags_map[keys(local.settings.tags_map)[count.index]]
  category_id = data.vsphere_tag_category.this[count.index].id

}
