# iac-worshop / aws

Simple AWS IAC recipes... Probably of questionable utility...

* ec2
    - ami-base
    - autoscalingroup-generic
        + Autoscaling group with an ALB for service and a NLB for maintenance
    - instance-elb
        + Public instance on a private subnet exposed through a classic load balancer
    - instance-generic
        + Public instance on a private subnet exposed through a network load balancer, or using an application load balancer
* lambda
    - lambda-and-layer shows how to add packages to a lambda using layers
* rds
    - public-rds-credentials-from-secret : Not quite a bright idea expose an RDS to internet...
* s3
    - tfstate-backend-from-config-file
    - tfstate-backend-from-workspace
    - bucket-backendless
    - bucket-from-config-file
    - bucket-from-workspace
    - bucket-static-web

### Building from configuration files.
  
In order to build infrastructure using configuration files:

+ terraform init -backend-config=&lt;Backend definition file&gt; -upgrade -reconfigure
+ terraform plan -var-file=&lt;Configuration file&gt;
+ terraform apply -var-file=&lt;Configuration file&gt;

### Building from workspace.

In order to build infrastructure using workspace files, where a mean of finding the configuration files based on the current workspace has been defined:

+ terraform init -backend-config=&lt;Backend definition file&gt; -upgrade -reconfigure
+ terraform workspace select &lt;Workspace&gt;
+ terraform plan
+ terrafrom apply

Sample excerpt to select the corresponding configuration file from the workspace name:

> locals {
>
>  workspace_path        = "./workspaces/${terraform.workspace}/configuration.yaml"
>
>  workspace             = file(local.workspace_path)
>
>  settings              = yamldecode(local.workspace)
>
>}

to later access the properties use:

> local.settings.&lt;Property name&gt;


