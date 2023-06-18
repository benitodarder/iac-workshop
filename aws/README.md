# iac-worshop / AWS

Simple AWS IAC recipes... Probably of questionable utility...

* rds
  -  public-rds-credentials-from-secret : Not quite a bright idea expose an RDS to internet...
* s3
  -  terraform-backend-from-config-file
  -  terraform-backend-from-workspace
  -  bucket-backendless
  -  bucket-from-config-file
  -  bucket-from-workspace
  
In order to build infrastructure using configuration files:

+ terraform init -backend-config=<Backend file> -upgrade -reconfigure
+ terraform plan -var-file=<Configuration file>
+ terraform apply -var-file=<Configuration file>

In order to build infrastructure using workspace files, where a mean of finding the configuration files based on the current workspace has been defined:

+ terraform init -backend-config=<Config folder>/backend.tfvars -upgrade -reconfigure
+ terraform workspace select <Workspace>
+ terraform plan
+ terrafrom apply

Sample excerpt to select the corresponding configuration file fronm the workspace name:

> locals {
>  workspace_path        = "./workspaces/${terraform.workspace}/configuration.yaml"
>  workspace             = file(local.workspace_path)
>  settings              = yamldecode(local.workspace)
>}

to later access the properties use:

> local.settings.<Property name>


