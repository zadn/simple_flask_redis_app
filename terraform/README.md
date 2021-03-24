# Terraform script for EKS

This directory contains all the script required to deploy the Flask application in 
an AWS EKS cluster using terraform. For EKS we do not require Consul for service discovery because it is handled by
 Kubernetes.


# Before Running

Before running the Terraform script, you need some packages to be installed:
* AWS CLI 
    
AWS CLI is used in two scenarios in this project, one for running the codebuild, so the docker image is present before
deploying the EKS cluster. The other usage is to configure Kubeconfig using EKS.

[Download Link](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html)

* Kubectl 

Kubectl is used to deploy the application in the created EKS cluster.

[Download Link](https://kubernetes.io/docs/tasks/tools/)

* Terraform 

Terraform is to apply this script in an AWS Account.

[Download Link](https://learn.hashicorp.com/tutorials/terraform/install-cli)

# Running the script

Make sure that AWS Credentials are configured through environment variables as shown below:
 ```bash
    export AWS_ACCESS_KEY_ID="anaccesskey"
    export AWS_SECRET_ACCESS_KEY="asecretkey"
```

All the variables are kept in `variables.tf` file. You have to insert a Personal Access Token obtained from GitHub account
in order to manage webhooks in the repository. Any modifications to the variable names can also be made through this 
file.

## init

Run the following command to initialise the providers

```bash
terraform init
```

This will initialise connection and import any missing packages for the project.

## plan

Run the following command to see what changes are going to be applied. This will not 
create, modify or destroy anything. 

```bash
terraform plan
```

## apply

The following command will deploy the changes we saw in plan stage.

```bash
terraform apply
```
A confirmation will be asked to verify that you want to make changes. Type `yes` when prompted to create all the 
resources.


