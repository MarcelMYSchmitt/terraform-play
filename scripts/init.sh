#!/bin/bash


echo "CLIENT_ID:" $CLIENT_ID
echo "SUBSCRIPTION_ID:" $SUBSCRIPTION_ID
echo "TENANT_ID:" $TENANT_ID
echo "LOCATION:" $LOCATION
echo "PROJECTTAG:" $PROJECTTAG
echo "ENVTAG:" $ENVTAG


TERRAFORM_STORAGE_NAME="terraformstorage$PROJECTTAG$ENVTAG"
TERRAFORM_RG_NAME=terraform-$PROJECTTAG-$SHORT_REGION-$ENVTAG-rg

echo "TERRAFORM_STORAGE_NAME:" $TERRAFORM_STORAGE_NAME
echo "TERRAFORM_RG_NAME:" $TERRAFORM_RG_NAME


echo "Login to Azure..."
az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET --tenant $TENANT_ID
az account set --subscription $SUBSCRIPTION_ID


echo "Create resource group..."
az group create -n $TERRAFORM_RG_NAME -l $LOCATION --tags "project=$PROJECTTAG" "env=$ENVTAG"

echo "Create storage account and container..."
az storage account create --resource-group $TERRAFORM_RG_NAME --name $TERRAFORM_STORAGE_NAME --location $LOCATION --sku Standard_LRS --tags "project=$PROJECTTAG" "env=$ENVTAG"

TERRAFORM_STORAGE_KEY=$(az storage account keys list --account-name $TERRAFORM_STORAGE_NAME --resource-group $TERRAFORM_RG_NAME --query [0].value -o tsv)

az storage container create -n tfstate --account-name $TERRAFORM_STORAGE_NAME --account-key $TERRAFORM_STORAGE_KEY

echo "Initialze Terraform with remote state handling...."
terraform init -backend-config="storage_account_name=$TERRAFORM_STORAGE_NAME" -backend-config="container_name=tfstate" -backend-config="access_key=$TERRAFORM_STORAGE_KEY" -backend-config="key=codelab.microsoft.tfstate" 
