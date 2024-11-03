# Terraform + Ansible Workaround for Xen Orchestra IP Configuration

## Overview

This repository contains Terraform and Ansible code to provision and configure VMs on Xen Orchestra (XO), with AWS S3 as remote state backend. It addresses a limitation in Xen: the inability to directly set or modify a Linux VM's IP address during provisioning. The workaround involves using Ansible to adjust network configurations on each VM post-deployment, by leveraging one XOA Template with a static ip address.

### Key Components

- **Terraform** manages VM provisioning on Xen Orchestra and S3-backed state management.
- **Ansible** handles post-provisioning configuration, setting custom IPs and rebooting VMs to apply changes.

## Repository Structure

- **`provider.tf`**  
  Defines providers for Xen Orchestra and AWS, along with backend configuration for state storage.

- **Ansible Playbooks**  
  Playbooks are configured to:
  - Provision VMs one by one, from the `10.100.170.235` Template (`terraform apply`).
  - Wait for initial connectivity.
  - Set custom IP and hostname with `nmcli` and reboot the VM to apply changes.
  - Verify connectivity after IP change
  - Go ahead with the next VM

## Requirements

- **Terraform** with S3 access for remote state.
- **Ansible** for post-deployment IP and hostname configuration.
- **Xen Orchestra** and **AWS** credentials defined in `variables.tf` or as environment variables.

## Usage

1. Fill out all configuration files and inventories.

2. **Initialize and Apply Terraform**  
   Run `terraform init` to initialize the configuration.

3. **Run Ansible Playbook**  
   The playbooks will automatically run as defined, configuring IPs for each VM.
