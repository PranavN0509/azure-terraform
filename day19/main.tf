resource "null_resource" "deployment_prep" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "echo Deployment started > deployment-${formatdate("YYYY-MM-DD-HH-mm-ss", timestamp())}.log"
  }
}


variable "prefix" {
  default = "tfvmex"
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-resources"
  location = "North Europe"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [azurerm_virtual_network.main]
}



resource "azurerm_network_security_group" "vm_nsg" {
  name                = "vm-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


# Public IP
resource "azurerm_public_ip" "vm_ip" {
  name                = "demo-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
  }

  depends_on = [azurerm_subnet.internal, azurerm_public_ip.vm_ip]
}


resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id

  depends_on = [azurerm_network_interface.main, azurerm_network_security_group.vm_nsg]
}




resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_D2s_v3"

  depends_on = [null_resource.deployment_prep, azurerm_network_interface.main, azurerm_network_security_group.vm_nsg, azurerm_public_ip.vm_ip]

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }



  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",

      # Create a sample welcome page
      "echo '<html><body><h1>#28daysofAZTerraform is Awesome!</h1></body></html>' | sudo tee /var/www/html/index.html",

      # Ensure nginx is running
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type     = "ssh"
      user     = "azureuser"
      password = "Password1234!"
      host     = azurerm_public_ip.vm_ip.ip_address
    }
  }


  provisioner "file" {
    source      = "config/sample.conf"
    destination = "/home/azureuser/sample.conf"

    connection {
      type     = "ssh"
      user     = "azureuser"
      password = "Password1234!"
      host     = azurerm_public_ip.vm_ip.ip_address
    }
  }
}




# Outputs

output "vm_public_ip" {
  value = azurerm_virtual_machine.main.name
}
