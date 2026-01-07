resource "random_pet" "lb_hostname" {
}



resource "azurerm_resource_group" "example" {
  name     = "day14-proj"
  location = "australiacentral"
}


resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Production"
  }

  depends_on = [ azurerm_resource_group.example ]
}

resource "azurerm_subnet" "example" {
  name                 = "testsubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/20"]

  depends_on = [ azurerm_virtual_network.example ]
}


resource "azurerm_network_security_group" "example" {
  name                = "myNSG"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}


resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id

  depends_on = [ azurerm_subnet.example, azurerm_network_security_group.example ]
}



resource "azurerm_public_ip" "example" {
  name                = "lb-publicIP"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
  sku                 = "Standard"
  # zones               = ["1", "2", "3"]
  domain_name_label   = "${azurerm_resource_group.example.name}-${random_pet.lb_hostname.id}"
}


resource "azurerm_lb" "example" {
  name                = "myLB"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                 = "myPublicIP"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}


resource "azurerm_lb_backend_address_pool" "example" {
  name            = "myBackEndAddressPool"
  loadbalancer_id = azurerm_lb.example.id

  depends_on = [ azurerm_lb.example ]
}


resource "azurerm_lb_rule" "example" {
  name                           = "http"
  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "myPublicIP"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.example.id]
  probe_id                       = azurerm_lb_probe.example.id


  depends_on = [ azurerm_lb.example ]
}


resource "azurerm_lb_nat_rule" "ssh" {
  name                           = "ssh"
  resource_group_name            = azurerm_resource_group.example.name
  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "myPublicIP"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.example.id

  depends_on = [ azurerm_lb.example ]
}

resource "azurerm_lb_probe" "example" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.example.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"


  depends_on = [ azurerm_lb.example ]
}



resource "azurerm_public_ip" "natgwip" {
  name                = "natgwip-publicIP"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
  sku                 = "Standard"
  # zones               = ["1"]
}



resource "azurerm_nat_gateway" "example" {
  name                    = "nat-gateway"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  # zones                   = ["1"]

  depends_on = [ azurerm_public_ip.example ]
}

resource "azurerm_subnet_nat_gateway_association" "example" {
  subnet_id      = azurerm_subnet.example.id
  nat_gateway_id = azurerm_nat_gateway.example.id

  depends_on = [ azurerm_subnet.example, azurerm_nat_gateway.example ]
}


resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.example.id
  public_ip_address_id = azurerm_public_ip.natgwip.id

  depends_on = [ azurerm_public_ip.natgwip, azurerm_nat_gateway.example ]
}
