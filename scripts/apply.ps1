Write-Host "Apply Terraform template...."

terraform apply -var env_tag=$ENVTAG -var long_region=$LOCATION -var short_region=$SHORT_REGION -var subscription_id=$SUBSCRIPTION_ID -var tenant_id=$TENANT_ID
