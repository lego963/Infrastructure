# Configure the OpenTelekomCloud Provider
provider "opentelekomcloud" {
  user_name   = var.user_name
  password    = var.password
  domain_name = var.domain_name
  tenant_name = var.tenant_name
  auth_url    = var.auth_url
}

resource "opentelekomcloud_vpc_v1" "vpc_1" {
  name = var.vpc_name
  cidr = "${var.net_address}.0/16"
}

resource "opentelekomcloud_vpc_eip_v1" "eip_1" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name       = "bandwidth_rgyrbu"
    size       = 25
    share_type = "PER"
  }
}


resource "opentelekomcloud_vpc_subnet_v1" "vpc_subnet_1" {
  name        = "subnet_rgyrbu"
  cidr        = "${var.net_address}.0/24"
  gateway_ip  = "${var.net_address}.1"
  vpc_id      = opentelekomcloud_vpc_v1.vpc_1.id
  primary_dns = "8.8.8.8"
}


resource "opentelekomcloud_compute_keypair_v2" "keypair_1" {
  name       = "keypair_rgyrbu"
  public_key = var.public_key
}

resource "opentelekomcloud_compute_secgroup_v2" "secgroup_1" {
  name        = "secgroup_rgyrbu"
  description = "Practice task security group"

  rule {
    cidr        = "0.0.0.0/0"
    from_port   = 80
    ip_protocol = "tcp"
    to_port     = 80
  }
  rule {
    cidr        = "0.0.0.0/0"
    from_port   = 443
    ip_protocol = "tcp"
    to_port     = 443
  }
  rule {
    cidr        = "0.0.0.0/0"
    from_port   = 22
    ip_protocol = "tcp"
    to_port     = 22
  }
}

resource "opentelekomcloud_compute_instance_v2" "vm_v2" {
  name        = "ecs_rgyrbu"
  image_id    = data.opentelekomcloud_images_image_v2.ubuntu.id
  flavor_name = "s2.medium.1"

  network {
    uuid = opentelekomcloud_vpc_subnet_v1.vpc_subnet_1.id
  }

  availability_zone = "eu-de-01"
  key_pair          = opentelekomcloud_compute_keypair_v2.keypair_1.name
  security_groups   = ["secgroup_rgyrbu"]
}

resource "opentelekomcloud_compute_floatingip_associate_v2" "fip_assoc_1" {
  floating_ip = opentelekomcloud_vpc_eip_v1.eip_1.publicip[0].ip_address
  instance_id = opentelekomcloud_compute_instance_v2.vm_v2.id
}

data "opentelekomcloud_images_image_v2" "ubuntu" {
  name = "Standard_Ubuntu_14.04_latest"
}