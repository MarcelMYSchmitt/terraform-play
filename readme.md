# Introduction

Some example scripts how to setup Infrastructe as Code by using terrafrom on Microsot Azure.

<br /> 


## Steps to be done before

<br /> 

1. Go to the Azure Portal and create a new under `App   registrations` in Azure Active Directory
2. Go into the new created app and go to `Certificates & secrets`
3. Create a new client secret
4. Please note your client id and client secret
5. Please note also your tenant id and subscription id

<br /> 

---

<br /> 

## What are we going to create

<br /> 

We will create following resources in Azure. 
1. Resource Group where we are going to place everything
2. Storage account with container, where we are going to store the state of the deployment
3. Azure Key Vault for Storing Secrets
4. Azure Container Registry for storing docker images
5. We are going to store the container access key in the key vault.

We will have some specific naming convention where we are going to use the environment like `dev`, the region like `we` or the resource as short name like `rg` in our scripts. We will see them later in the Azure portal.  


You should have at least then these following environment variables prepared:

```
APP_CLIENT_ID=1234
APP_CLIENT_SECRET=1234
SUBSCRIPTION_ID=1234
TENANT_ID=1234
ENVTAG=dev
LOCATION=westeurope
SHORT_REGION=we
```

<br /> 

---

<br /> 

## Let's go

<br /> 

We are going to build a docker image where we are going to place everything for the execution of the deployment.

<br /> 

Please build the docker image inside of this repository
```
docker build -t terraform . 
``` 

<br /> 

Run the docker image and use the env file
```
docker run -it --rm -v  %cd%\scripts\:/usr/src/terraform --env-file terraform.env terraform
```

<br /> 

Execute the files you want, for the beginning you have to init the terraform deployment. Therefore you will find `init.ps1`. After initiation you can then deploy your resources by using `apply.ps1`. For deletion you can use the `delete.ps1` file. 

<br /> 

--- 


## Further ideas

You can change and extend the deployment files for integrating it in the a deployment pipeline. There you could extend the `terraform apply` statement by following parameter `input=false`. See here: https://learn.hashicorp.com/tutorials/terraform/automate-terraform?in=terraform/automation&utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS