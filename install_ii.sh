#!/bin/bash

if [ -f .env ]; then
  echo " Loading config from .env"
  set -o allexport
  source .env
  set +o allexport
else
  echo ".env file not found."
  exit 1
fi 

echo " Installing IIS on VM: $VM_NAME in resource group: $RG"

#Run Powershell command to install IIS
az vm run-command invoke \
 --resource-group "$RG" \
 --name "$VM_NAME" \
 --command-id RunPowerShellScript \
 --scripts "Install-WindowsFeature -Name Web-Server -IncludeManagementTools"


#Open HTTP port in NSG
echo "Port 80 Open"

az network nsg rule create \
 --resource-group "$RG" \
 --nsg-name "${VM_NAME}-nsg" \
 --name Allow-HTTP \
 --protocol Tcp \
 --priority 1001 \
 --destination-port-range 80 \
 --access Allow \
 --direction Inbound \
 --output none || true
