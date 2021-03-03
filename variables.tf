variable "ibmcloud_api_key" {}
variable "machine_type" {
   default = "b3c.4x16"
}
variable "hardware" {
   default = "shared"
}

variable "datacenter" {
  default = "wdc07"
}

variable "default_pool_size" {
  default = "3"
}

variable "private_vlan_id" {}

variable "public_vlan_id" {}

variable "cluster_name" {
  default = "cluster"
}
variable kube_version {
  #default = "3.11.104_openshift"
  default = "1.20.4"
}


variable "resource_group_name" {
  default = "default"
}
