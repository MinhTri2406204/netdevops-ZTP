terraform {
  required_version = ">= 1.0.0"

  required_providers {
    eveng = {
      source  = "hashicorp.com/edu/eveng"
      version = "0.1.2"
    }
  }
}

provider "eveng" {
  host     = "http://192.168.88.136"
  username = "admin"
  password = "eve"
}

variable "router_count" {
  default = 1
}

resource "eveng_lab" "example" {
  name = "doan"
}

resource "eveng_network" "bridged" {
  lab_path = eveng_lab.example.path

  name = "Cloud1"
  icon = "01-Cloud-Default.svg"
  type = "pnet1"

  top  = 200
  left = 400
}

resource "eveng_node" "router" {

  count = var.router_count

  lab_path = eveng_lab.example.path

  name = "Node${count.index + 1}"

  template = "csr1000vng"
  type     = "qemu"

  ram = 4096

  top  = 400
  left = 100 + (count.index * 150)
}

resource "eveng_node_link" "cloud_connection" {

  count = var.router_count

  lab_path = eveng_lab.example.path

  network_id = eveng_network.bridged.id

  source_node_id = eveng_node.router[count.index].id

  source_port = "Gi1"
}

#resource "eveng_start_nodes" "start" {

 # lab_path = eveng_lab.example.path

 # depends_on = [
 #   eveng_node_link.cloud_connection
 # ]
#}