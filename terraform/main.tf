resource "azurerm_resource_group" "vm-rg" {
  name     = "vm-instances-rg"
  location = "France Central"
}
resource "azurerm_virtual_network" "kubernetes-virtual-network" {
  name                = "kubernetes-cluster-v-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vm-rg.location
  resource_group_name = azurerm_resource_group.vm-rg.name
}

resource "azurerm_subnet" "kubernetes-subnet" {
  name                 = "kubernetes-subnet"
  resource_group_name  = azurerm_resource_group.vm-rg.name
  virtual_network_name = azurerm_virtual_network.kubernetes-virtual-network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "worker-0-nic" {
  name                = "worker-0-nic"
  location            = azurerm_resource_group.vm-rg.location
  resource_group_name = azurerm_resource_group.vm-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kubernetes-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "worker-0" {
  name                  = "worker-0"
  resource_group_name = azurerm_resource_group.vm-rg.name
  location            = azurerm_resource_group.vm-rg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "Mahdi123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.worker-0-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "worker-1-nic" {
  name                = "worker-1-nic"
  location            = azurerm_resource_group.vm-rg.location
  resource_group_name = azurerm_resource_group.vm-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kubernetes-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "worker-1" {
  name                  = "worker-1"
  resource_group_name = azurerm_resource_group.vm-rg.name
  location            = azurerm_resource_group.vm-rg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "Mahdi123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.worker-1-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}