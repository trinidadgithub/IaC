# Azure Case Study AKS

Creating a dedicated Azure Resource Group for a specific service (like a Kubernetes cluster) is a great way to organize and manage resources. Here’s how it works and why it’s beneficial:

**1. Dedicated Resource Group for Each Major Service**

For example, if you're deploying an Azure Kubernetes Service (AKS) cluster, you might create a dedicated resource group just for this service. This resource group would contain all resources that are specific to the Kubernetes cluster and supporting resources, such as virtual networks, subnets, network security groups, and load balancers.

**2. Benefits of Service-Specific Resource Groups**

- **Simplified Management:** Organizing all resources related to a particular service in one group makes it easier to manage configurations, monitor usage, and apply security controls specific to that service.
- **Lifecycle Management:** When you want to decommission or redeploy a service, you can delete the entire resource group safely, knowing it won’t affect unrelated resources.
- **Access Control:** You can apply Role-Based Access Control (RBAC) at the resource group level, so only specific users or teams have access to Kubernetes-related resources.

**3. Setting Up Networking Resources Within the Service Resource Group**

For an AKS deployment, you’ll typically need:

- **Virtual Network:** The network for cluster nodes and pods.
- **Subnets:** Subdivide the virtual network into dedicated subnets for AKS components.
- **Network Security Groups (NSGs):** Control access and traffic rules for your subnets.
- **Load Balancers and Public IPs:** For exposing AKS services externally.

Here’s an example Terraform configuration to set up a resource group with a Kubernetes cluster and its associated networking resources:

```terraform
provider "azurerm" {
  features {}
}

# Resource Group for AKS
resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-resources"
  location = "East US"
}

# Virtual Network for AKS
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aks-vnet"
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  address_space       = ["10.0.0.0/16"]
}

# Subnet for AKS nodes
resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group for AKS
resource "azurerm_network_security_group" "aks_nsg" {
  name                = "aks-nsg"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name

  security_rule {
    name                       = "allow-https"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Azure Kubernetes Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name       = "agentpool"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}

# Associate NSG with the Subnet (if needed)
resource "azurerm_subnet_network_security_group_association" "aks_subnet_nsg" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}
```

### Explanation of the Setup

- Resource Group (aks-resources): This contains all the AKS-related resources.
- Virtual Network and Subnet: The AKS cluster’s nodes are deployed within this virtual network and subnet.
- Network Security Group: Controls inbound and outbound traffic for the subnet.
- Azure Kubernetes Service Cluster: Configures the AKS cluster with a single node pool.

### Benefits of this Setup

- Isolation: AKS-related networking resources are isolated from other applications.
- Clear Structure: Resource groups for other services, like databases or storage, can be created separately.
- Ease of Scaling: If you need additional AKS clusters (e.g., for development or testing), you can replicate this structure in separate resource groups.

### Summary

Using dedicated resource groups for each major service, like a Kubernetes cluster, and placing relevant network resources within them is an efficient way to organize Azure infrastructure. This setup improves manageability, security, and scalability, and follows Azure’s best practices for infrastructure organization.
