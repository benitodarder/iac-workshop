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

+ terraform init -backend-config=&lt;Backend file&gt; -upgrade -reconfigure
+ terraform plan -var-file=&lt;Configuration file&gt;
+ terraform apply -var-file=&lt;Configuration file&gt;

In order to build infrastructure using workspace files, where a mean of finding the configuration files based on the current workspace has been defined:

+ terraform init -backend-config=&lt;Config folder&gt;/backend.tfvars -upgrade -reconfigure
+ terraform workspace select &lt;Workspace&gt;
+ terraform plan
+ terrafrom apply

Sample excerpt to select the corresponding configuration file fronm the workspace name:

&gt; locals {
&gt;  workspace_path        = "./workspaces/${terraform.workspace}/configuration.yaml"
&gt;  workspace             = file(local.workspace_path)
&gt;  settings              = yamldecode(local.workspace)
&gt;}

to later access the properties use:

&gt; local.settings.&lt;Property name&gt;


