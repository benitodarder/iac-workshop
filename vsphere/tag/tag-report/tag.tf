locals {
  tags_per_category_id = flatten([
    for category in local.settings.cluster.tags.categories : [
      for tag in category.tags : {
        id       = local.categories_id_by_name[category.name],
        tag_name = tag
      }
    ]
  ])
}

data "vsphere_tag" "this" {

  for_each = { for id, tag_name in local.tags_per_category_id : id => tag_name }

  name = each.value.tag_name

  category_id = each.value.id
}
