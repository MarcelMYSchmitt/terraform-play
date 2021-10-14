FROM mcr.microsoft.com/azure-cli

# libc6 required for some downloaded executable files to work (missing in go compilation for linux systems)
#RUN apk add libc6-compat

# Azure CLI storage account related commands do not work without
RUN pip install --upgrade pip

ARG TERRAFORM_VERSION=0.12.12

WORKDIR /usr/downloads

# install terraform
RUN curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform.zip
RUN unzip terraform.zip
RUN mv terraform /usr/local/bin

ENV TF_DATA_DIR "/.terraform"
ARG PLUGIN_DIRECTORY=/.terraform/plugins/linux_amd64
RUN mkdir -p ${PLUGIN_DIRECTORY}


WORKDIR /usr/src/terraform

COPY . .

ENTRYPOINT ["/bin/bash"]