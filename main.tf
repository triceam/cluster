resource "ibm_container_cluster" "cluster" {
  name              = "${var.cluster_name}${random_id.name.hex}"
  datacenter        = "${var.datacenter}"
  default_pool_size = "${var.default_pool_size}"
  machine_type      = "${var.machine_type}"
  hardware          = "${var.hardware}"
  kube_version      = "${var.kube_version}"
  public_vlan_id    = "${var.public_vlan_id}"
  private_vlan_id   = "${var.private_vlan_id}"
  resource_group_id   = "${data.ibm_resource_group.resourceGroup.id}"
}

data "ibm_resource_group" "resourceGroup" {
  name     = "${var.resource_group_name}"
}

resource "random_id" "name" {
  byte_length = 4
}
