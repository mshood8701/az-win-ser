# Windows Server Web Deployment on Azure
This project demonstrates how to deploy a simple static website (HTML, CSS, JS) on a Windows Server VM running IIS on Microsoft Azure.


## Contents

- Azure CLI commands to create VM & infrastructure
- Automated script to upload web files 
- Manual method using RDP to copy files into IIS folder

---

## VM Setup

Provisioned with the following configuration:

- **OS:** Windows Server 2022 Datacenter
- **Web Server:** IIS (installed by default)
- **Public IP:** Static with RDP access on port 3389
- **Location:** West US

## Prerequisites

- Azure CLI installed
- Azure subscription access
- HTML/CSS/JS files (`index.html`, `style.css`, `script.js`)
- If not using script: access to RDP and local file sharing

