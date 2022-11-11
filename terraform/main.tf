data "azurerm_resource_group" "resource-grp" {
  name = var.resource_group_name
}

module "vnet_subnet" {
  source = "./modules/VNET-subnet"
  resource_group_name = var.resource_group_name
  resource_group_location = data.azurerm_resource_group.resource-grp.location
  vnet_name = "kubernetes-virtual-network"
  subnet_name = "kubernetes-subnet"
}

resource "azurerm_network_interface" "worker-nics" {
  count = length(var.worker-nic-names)
  name                = var.worker-nic-names[count.index]
  location            = data.azurerm_resource_group.resource-grp.location
  resource_group_name = data.azurerm_resource_group.resource-grp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet_subnet.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "workers" {
  count = length(var.workers)
  name                = var.workers[count.index]
  resource_group_name = data.azurerm_resource_group.resource-grp.name
  location            = data.azurerm_resource_group.resource-grp.location
  size                = var.worker-size
  admin_username      = var.worker-admin-username
  admin_ssh_key {
    username   = var.worker-admin-username
    public_key = file("./id_rsa.pub")
  }
  network_interface_ids = [
    azurerm_network_interface.worker-nics[count.index].id,
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

/**
resource "azurerm_public_ip" "master-public-ip" {
  name                = "master-public-ip"
  resource_group_name = data.azurerm_resource_group.resource-grp.name
  location            = data.azurerm_resource_group.resource-grp.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "master-nic" {
  name                = "master-nic"
  location            = data.azurerm_resource_group.resource-grp.location
  resource_group_name = data.azurerm_resource_group.resource-grp.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kubernetes-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.master-public-ip.id

  }
}

resource "azurerm_linux_virtual_machine" "master" {
  name                  = "master"
  resource_group_name = data.azurerm_resource_group.resource-grp.name
  location            = data.azurerm_resource_group.resource-grp.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("./id_rsa.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.master-nic.id,
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

resource "azurerm_network_security_group" "ssh-inbound" {
  name                = "allow-inbound-ssh"
  location            = data.azurerm_resource_group.resource-grp.location
  resource_group_name = data.azurerm_resource_group.resource-grp.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "ssh-to-kubernetes-subnet" {
  subnet_id                 = module.vnet_subnet.subnet_id
  network_security_group_id = azurerm_network_security_group.ssh-inbound.id
}
*/