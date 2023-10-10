locals {
  categories_name_by_id = { for category in data.vsphere_tag_category.this : category.id => category.name }
  categories_id_by_name = { for category in data.vsphere_tag_category.this : category.name => category.id }
}


data "vsphere_tag_category" "this" {

  for_each = { for index, record in local.settings.cluster.tags.categories : index => record }


  name = each.value.name
}

