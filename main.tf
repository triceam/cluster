
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




# DONT MERGE, this is to show compliance scan!
# Create a virtual server with the SSH key
resource "ibm_compute_vm_instance" "my_server_2" {
  hostname          = "host-b.example.com"
  domain            = "example.com"
  ssh_key_ids       = [123456, ibm_compute_ssh_key.test_key_1.id]
  os_reference_code = "CENTOS_6_64"
  datacenter        = "ams01"
  network_speed     = 10
  cores             = 1
  memory            = 1024
}

# Reference details of the IBM Cloud space
data "ibm_space" "space" {
  space = var.space
  org   = var.org
}

# Create an instance of an IBM service
resource "ibm_service_instance" "service" {
  name       = var.instance_name
  space_guid = data.ibm_space.space.id
  service    = "speech_to_text"
  plan       = "lite"
  tags       = ["cluster-service", "cluster-bind"]
}

# Create a Cloud Functions action
resource "ibm_function_action" "nodehello" {
  name      = "action-name"
  namespace = "function-namespace-name"
  exec {
    kind = "nodejs:6"
    code = file("hellonode.js")
  }
}

# Create a IS VPC and instance
resource "ibm_is_vpc" "testacc_vpc" {
  name = "testvpc1"
}

resource "ibm_is_subnet" "testacc_subnet" {
  name            = "testsubnet1"
  vpc             = ibm_is_vpc.testacc_vpc.id
  zone            = "us-south-1"
  ipv4_cidr_block = "10.240.0.0/24"
}

resource "ibm_is_ssh_key" "testacc_sshkey" {
  name       = "testssh1"
  public_key = "<your_public_ssh_key>"
}

resource "ibm_is_instance" "testacc_instance" {
  name    = "testinstance1"
  image   = "7eb4e35b-4257-56f8-d7da-326d85452591"
  profile = "b-2x8"

  primary_network_interface {
    subnet = ibm_is_subnet.testacc_subnet.id
  }

  vpc       = ibm_is_vpc.testacc_vpc.id
  zone      = "us-south-1"
  keys      = [ibm_is_ssh_key.testacc_sshkey.id]
  user_data = file("nginx.sh")
}

resource "ibm_is_floating_ip" "testacc_floatingip" {
  name   = "testfip"
  target = ibm_is_instance.testacc_instance.primary_network_interface[0].id
}
