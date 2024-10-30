# Azure Case Study for network management

Introduction:  Creating a dedicated network resource group (often called a “network account”) to manage networking components is a good practice, especially in environments where networking resources are shared across multiple applications or projects. Here’s why this approach is beneficial and how to set it up:

Why Use a Dedicated Network Resource Group?

**1. Centralized Management:** By placing all networking resources (e.g., virtual networks, subnets, network security groups) in a dedicated resource group, you simplify managing and monitoring network resources, ensuring consistent configurations and easier troubleshooting.

**2. Reusability Across Applications:** A central network resource group allows multiple applications or resource groups to share a common network infrastructure, reducing redundancy.

**3. Access Control and Security:** Role-Based Access Control (RBAC) can be applied to the network resource group to restrict access, so only specific users or services can modify networking components.

**4. Ease of Policy Application:** With a dedicated network resource group, you can apply policies, such as restrictions on IP ranges or mandatory tagging, specifically to networking resources without impacting other resource groups.

### Setting Up a Network Resource Group

Here’s how to structure the network resource group for easy and secure management:

**Create the Network Resource Group:** Use a dedicated name like network-rg or shared-network that makes its purpose clear.

**Add Network Components:** Create resources such as virtual networks (VNets), subnets, network security groups (NSGs), public IP addresses, and load balancers within this resource group.
        Configure the network settings in a way that allows secure connections across other resource groups and applications.

### Example Terraform Code for Network Resource Group and Components

Here’s an example Terraform configuration that creates a dedicated network resource group and defines common networking resources:

```terraform
# Define the Network Resource Group
resource "azurerm_resource_group" "network_rg" {
  name     = "network-resources"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "main-vnet"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  address_space       = ["10.0.0.0/16"]
}

# Subnet for Application
resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "app-nsg"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate the NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  subnet_id                 = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

```

**In this configuration:**

- network-resources resource group holds all network resources.
- A Virtual Network (VNet) and a Subnet are defined, which can be reused by other application resources.
- A Network Security Group (NSG) with a basic SSH rule is created, and associated with the subnet for security.

**Best Practices**

- **Use Tags:** Tag your networking resources with Environment, Owner, or Purpose to easily track and manage them.
- **Lock Shared Network Resources:** Apply locks on critical shared network resources to prevent accidental deletion.
- **Separate Network Resource Groups by Environment:** If you have multiple environments (e.g., Production, Development), create a separate network resource group for each to maintain isolation.

By using this approach, a network resource group functions as a centralized hub for networking components, simplifying management and allowing you to scale as you add more applications.

Let's break this down further.

In Terraform, you create Azure network components directly by defining resources for each component you need within a Resource Group.
Example Terraform Resources for Network Components

Here are the primary Terraform resources for common Azure networking components:

**1. Virtual Network:** The foundational network resource.

```terraform
resource "azurerm_virtual_network" "example" {
  name                = "my-vnet"
  location            = "East US"
  resource_group_name = azurerm_resource_group.network_rg.name
  address_space       = ["10.0.0.0/16"]
}
```

**2. Subnet:** Define subnets within the virtual network.
```terraform
resource "azurerm_subnet" "example" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}
```
**3.  Network Security Group (NSG):** Manages security rules.
```terraform
resource "azurerm_network_security_group" "example" {
  name                = "my-nsg"
  location            = "East US"
  resource_group_name = azurerm_resource_group.network_rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
```
**4. Public IP Address:** Allocates a public IP for use with other network resources.
```terraform
resource "azurerm_public_ip" "example" {
  name                = "my-public-ip"
  location            = "East US"
  resource_group_name = azurerm_resource_group.network_rg.name
  allocation_method   = "Static"
}
```
**5. Network Interface:** Associates a virtual network, subnet, and NSG for VM connectivity.
```terraform
resource "azurerm_network_interface" "example" {
  name                = "my-nic"
  location            = "East US"
  resource_group_name = azurerm_resource_group.network_rg.name

  ip_configuration {
    name                          = "my-ipconfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}
```
### Organizing Network Components in a Resource Group

To organize these resources, first create a Resource Group as your “network account” container, then add each of these resources to it. Here’s a full example:
```terraform
provider "azurerm" {
  features {}
}

# Resource Group for Networking Resources
resource "azurerm_resource_group" "network_rg" {
  name     = "network-resources"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "main-vnet"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-1"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-1"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Public IP Address
resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip-1"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
  allocation_method   = "Static"
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-1"
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}
```

**In this setup:** 

- All network resources (VNet, Subnet, NSG, Public IP, NIC) are organized within the network-resources resource group.
- You can add additional network resources to this resource group as needed, maintaining a clean, centralized network management setup.

**Summary**

In Azure, network resources are created through and organized into individual network resources within a dedicated resource group, giving you full control over network configurations while keeping them separate from other resources.