terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

module "network" {
  source = "Azure/network/azurerm"

  resource_group_name = azurerm_resource_group.main.name
  vnet_name           = var.virtual_network_name
  address_spaces      = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.0.0/24"]
  subnet_names        = ["snet-k8s-01"]

  tags         = var.tags
  depends_on   = [azurerm_resource_group.main]
  use_for_each = true
}

module "control-plane-node" {
  source = "Azure/compute/azurerm"

  resource_group_name              = azurerm_resource_group.main.name
  data_disk_size_gb                = 64
  location                         = var.location
  data_sa_type                     = "Premium_LRS"
  delete_data_disks_on_termination = true
  vm_os_publisher                  = "Canonical"
  vm_os_offer                      = "0001-com-ubuntu-server-focal"
  vm_os_sku                        = "20_04-lts"
  vm_hostname                      = "vm-control-plane-node"
  nb_instances                     = 1
  vm_size                          = "Standard_B4ms"
  remote_port                      = "22"
  public_ip_dns                    = ["pip-control-plane-node"]
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  enable_ssh_key                   = true
  ssh_key                          = var.ssh_pub_key_path

  tags       = var.tags
  depends_on = [azurerm_resource_group.main]
}

module "worker-node" {
  source = "Azure/compute/azurerm"

  resource_group_name              = azurerm_resource_group.main.name
  data_disk_size_gb                = 64
  location                         = var.location
  data_sa_type                     = "Premium_LRS"
  delete_data_disks_on_termination = true
  vm_os_publisher                  = "Canonical"
  vm_os_offer                      = "0001-com-ubuntu-server-focal"
  vm_os_sku                        = "20_04-lts"
  vm_hostname                      = "vm-worker-node"
  nb_instances                     = 2
  vm_size                          = "Standard_B4ms"
  remote_port                      = "22"
  public_ip_dns                    = ["pip-worker-node"]
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  enable_ssh_key                   = true
  ssh_key                          = var.ssh_pub_key_path

  tags       = var.tags
  depends_on = [azurerm_resource_group.main]
}
