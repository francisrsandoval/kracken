/*
  This template demonstrates:
    * create a VM  on Azure
    * runs docker container with network service API
*/

provider "azurerm" {
#  version = "~>2.0"
  features {}
}


resource "azurerm_resource_group" "OpenSpaceRG" {
  name = "OpenSpace-server-RG"
  location = "eastus"
    tags = {
        environment = "OpenSpace Demo"
    }
}

resource "azurerm_virtual_network" "OpenSpaceVnet" {
    name                = "OpenSpaceVnet"
    resource_group_name = azurerm_resource_group.OpenSpaceRG.name
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"

    tags = {
        environment = "OpenSpace Demo"
    }
}

resource "azurerm_subnet" "OpenSpaceSubnet" {
    name                 = "OpenSpaceSubnet"
    resource_group_name  = azurerm_resource_group.OpenSpaceRG.name
    virtual_network_name = azurerm_virtual_network.OpenSpaceVnet.name
    address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "OpenSpaceSG" {
    name                = "OpenSpaceSG"
    resource_group_name = azurerm_resource_group.OpenSpaceRG.name
    location            = azurerm_resource_group.OpenSpaceRG.location

    # can ssh into VM on port 22 and access test nginx on prt 80
    security_rule {
       name                       = "test123"
       priority                   = 100
       direction                  = "Inbound"
       access                     = "Allow"
       protocol                   = "Tcp"
       source_port_range          = "*"
       destination_port_range     = "*"
       source_address_prefix      = "*"
       destination_address_prefix = "*"
   }
}

resource "azurerm_public_ip" "OpenSpacePIP-mgmt" {
    name                         = "OpenSpacePIP-mgmt"
    resource_group_name          = azurerm_resource_group.OpenSpaceRG.name
    location                     = azurerm_resource_group.OpenSpaceRG.location
    allocation_method            = "Dynamic"

    tags = {
        environment = "OpenSpace Demo"
    }
}

resource "azurerm_network_interface" "mgmtNIC" {
    name                        = "mgmtNIC"
    resource_group_name          = azurerm_resource_group.OpenSpaceRG.name
    location                     = azurerm_resource_group.OpenSpaceRG.location

    ip_configuration {
        name                          = "mgmtNicConfiguration"
        subnet_id                     = azurerm_subnet.OpenSpaceSubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.OpenSpacePIP-mgmt.id
    }

    tags = {
        environment = "OpenSpace Demo"
    }
}


# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "mgmtAssociation" {
    network_interface_id      = azurerm_network_interface.mgmtNIC.id
    network_security_group_id = azurerm_network_security_group.OpenSpaceSG.id
}

resource "azurerm_linux_virtual_machine" "OpenSpaceVM" {
    name                  = "OpenSpace-server-VM"
    resource_group_name   = azurerm_resource_group.OpenSpaceRG.name
    location              = azurerm_resource_group.OpenSpaceRG.location
    network_interface_ids = [azurerm_network_interface.mgmtNIC.id]
    size                  = "Standard_DS3_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }
/*
    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
*/
    # reference our image built w packer. ubuntu 16.04 w docker installed
    source_image_id = "/subscriptions/d9ae244a-86d3-4679-88a9-25dc0ef64f4d/resourceGroups/sigrg/providers/Microsoft.Compute/images/myPackerImage"

    computer_name  = "OpenSpaceVM"
    admin_username = "OSadmin"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "OSadmin"
        public_key     = file(var.ssh_public_key)
    }

    tags = {
        environment = "OpenSpace Demo"
    }
}


output "public_IP" { value = azurerm_linux_virtual_machine.OpenSpaceVM.public_ip_address }

# simple example of executing a command on the VM
/*
#        "commandToExecute": "docker run -it --rm -d -p 8080:80 --name web nginx"

resource "azurerm_virtual_machine_extension" "OpenSpaceVMEx" {
    name                 = "OpenSpace-server-VMEx"
    virtual_machine_id   = azurerm_linux_virtual_machine.OpenSpaceVM.id
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"

    settings = <<SETTINGS
      {
        "commandToExecute": "sudo docker login -u=frankptech -p=xysfy0-xazkuS-kevfos",
        "commandToExecute": "sudo docker run -p 8080:8080 -it --entrypoint /bin/sh frankptech/openspace:ns-api"
      }
  SETTINGS


    tags = {
      environment = "OpenSpace Demo"
    }
}
*/
