
# Template data Variables
data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}
  
resource "ibm_container_cluster" "create_cluster" {
  name              = var.cluster_name
  datacenter        = var.datacenter
  default_pool_size = var.default_pool_size
  machine_type      = var.machine_type
  hardware          = var.hardware
  resource_group_id = data.ibm_resource_group.resource_group.id
  kube_version      = var.kube_version
  public_vlan_id    = var.public_vlan_id
  private_vlan_id   = var.private_vlan_id
}


data "ibm_container_cluster_config" "config" {
  cluster_name_id = ibm_container_cluster.create_cluster.id
  resource_group_id = data.ibm_resource_group.resource_group.id
}

//Variable required for content catalog to select terraform version
variable "TF_VERSION" {
  default = "0.12"
  description = "terraform engine version to be used in schematics"
}
terraform {
  required_version = "> 0.12.0"
}
