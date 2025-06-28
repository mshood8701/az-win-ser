#!/bin/bash

# Load enviroment variables
if [ -f .env ]; then 
  echo "Loading config from .env..."
  set -o allexport
  source .env
  set +o allexport
else
  echo "config file cannot be found, EXITING."
  exit 1
fi 

echo " Starting VM provisiong in resource group: $RG"

# Create virtual network and subnet
az network vnet create \
  --resource-group $RG \
  --name ${VM_NAME}-vnet \
  --subnet-name subnet \
  --address-prefix 10.0.0.0/16 \
  --subnet-prefix 10.0.1.0/24

# Create Network Security Group with RDP rule
az network nsg create --resource-group $RG --name ${VM_NAME}-nsg
az network nsg rule create \
  --resource-group $RG --nsg-name ${VM_NAME}-nsg \
  --name Allow-RDP --protocol Tcp --priority 1000 \
  --destination-port-range 3389 --access Allow --direction Inbound

# Create Basic Public IP
az network public-ip create \
  --resource-group $RG \
  --name ${VM_NAME}-pip \
  --sku Basic \
  --allocation-method static

# Create NIC
az network nic create \
  --resource-group $RG \
  --name ${VM_NAME}-nic \
  --vnet-name ${VM_NAME}-vnet \
  --subnet subnet \
  --network-security-group ${VM_NAME}-nsg \
  --public-ip-address ${VM_NAME}-pip

# Create VM
az vm create \
  --resource-group $RG \
  --name $VM_NAME \
  --image Win2022Datacenter \
  --size $VM_SIZE \
  --admin-username $ADMIN_USER \
  --admin-password $ADMIN_PASS \
  --nics ${VM_NAME}-nic \
  --public-ip-sku Basic \
  --os-disk-name "${VM_NAME}-osdisk"\
  --storage-sku Standard_LRS
  

