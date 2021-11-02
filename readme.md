# Introduction

Some example scripts how to setup Infrastructe as Code by using terrafrom on Microsoft Azure. There are different ways to realize the infrastructure creation. In the following example we will create a service principal and assign it on subscription level. You could also assign it on resource group level. It depends on how much automation you want to have. Here, we want to create everything automatically. We want to have a resource group for the terraform storage/state and also a resource group where we are going to create our custom resources. 

<br /> 


## Steps to be done before

<br /> 

1. Go to the Azure Portal and create a new under `App registrations` in Azure Active Directory
2. Go into the new created app and go to `Certificates & secrets`
3. Create a new client secret
4. Please note your client id and client secret
5. Please note also your tenant id and subscription id
6. Go to your subscription
7. Click on `Access control (IAM)`
8. Click on `Add` and `Add role assignment`
9. Choose `Owner` or `Contributor` in Tab `Role`.
10. Choose your app registration in Tab `Members`
11. Review and assign your app registration with the chosen role to your subscription.

<br /> 

The client secret from the Azure Portal UI could have non ASCII characters which will lead maybe to problems in the CLI: https://github.com/ansible/ansible/issues/54914 Example: If you have characters lie `~` in your secret you will get error messages, that your secret is not valid anymore.
```
Get Token request returned http error: 401 and server response: {"error":"invalid_client","error_description":"AADSTS7000222: The provided client secret keys are expired.
```
If you have any problems with the client secret, you can also create it via Azure CLI. You can create your app registration and copy the password without the special characters as alternative. Please regard that you have to enter a valid custom domain as parameter: https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/add-custom-domain

Otherwise you will get errors.
```
Values of identifierUris property must use a verified domain of the organization or its subdomain:
```
You can also directly add the app registration as contributor or owner to the subscription when you set the subscription id in the `scopes` parameter.

```
az ad sp create-for-rbac -n "customdomainname.onmicrosoft.com" --role Contributor --scopes /subscriptions/{subscriptionId}
```

You will get the created registration with its id and secret as response.
```
{
  "appId": "8a87f2d4-6d0d-4cf0-8d58-9c01d60c5de0",
  "displayName": "customdomainname.onmicrosoft.com",
  "name": "http://customdomainname.onmicrosoft.com",
  "password": "ff503496-bb9c-4d7b-8b37-887e3190b869",
  "tenant": "ac6bb21c-57e9-4c9f-9ef9-972e9acab71b"
}
```
Now you can go on and create your infrastructure.

<br />

---

<br /> 

## What are we going to create

<br /> 

We will create following resources in Azure. 
1. One resource group where we are going to place our terraform state inside a storage account
2. Another resource group where we ware going to store following resources: 
   - Azure Key Vault for Storing Secrets
   - Azure Container Registry for storing docker images
   - We are going to store the container access key in the key vault and a test secret.

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
PROJECTTAG=sma
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
docker run -it --rm --env-file terraform.env terraform
```

<br />

You can also use the docker-compose file by executing followong commands.
```
docker-compose up --build 
docker-compose run --rm terraform-play
```

<br /> 

Execute the files you want, for the beginning you have to init the terraform deployment. Therefore you will find `init.sh`. After initiation you can then deploy your resources by using `apply.sh`. For deletion you can use the `delete.sh` file. 

<br /> 

--- 

<br />

## Info

<br /> 

There are different kind of keyvault permissions, we take the easy way....our service principal will have the permissions to create and get secrets. We could also create another service principal and assign some restricted rights to it. So we would have a better security concept. 

Secrets Permissions  
`[Backup Delete Get List Purge Recover Restore Set]`


Storage Permissions  
`[Backup Delete DeleteSAS Get GetSAS List ListSAS Purge Recover RegenerateKey Restore Set SetSAS Update]`

Key Permissions  
`[Backup Create Decrypt Delete Encrypt Get Import List Purge Recover Restore Sign UnwrapKey Update Verify WrapKey]`

<br /> 

---

<br /> 

## Further ideas

<br /> 

You can change and extend the deployment files for integrating it in the a deployment pipeline. There you could extend the `terraform apply` statement by following parameter `input=false`. See here: https://learn.hashicorp.com/tutorials/terraform/automate-terraform?in=terraform/automation&utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS



