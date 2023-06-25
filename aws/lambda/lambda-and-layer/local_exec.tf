resource "null_resource" "pip_install_requirements" {

  provisioner "local-exec" {
    command = "cd ${local.settings.layer_folder}/python && pip install -r requirements.txt -t ."
  }
}
