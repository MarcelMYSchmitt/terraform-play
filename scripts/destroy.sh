#!/bin/bash

echo "Apply Terraform template..."
terraform destroy -var project_tag=$PROJECTTAG -var env_tag=$ENVTAG -var long_region=$LOCATION -var short_region=$SHORT_REGION -var subscription_id=$SUBSCRIPTION_ID -var tenant_id=$TENANT_ID  -var client_id=$CLIENT_ID -var client_secret=$CLIENT_SECRET 