output "categories_summary" {
  value = { for category in data.vsphere_tag_category.this : category.id => {
    name = category.name,
  associable_types = category.associable_types } }

}

output "tags_summary" {
  value = { for tag in data.vsphere_tag.this : tag.id => {
    name          = tag.name,
    category_id   = tag.category_id
    category_name = local.categories_name_by_id[tag.category_id]
    }
  }
}

