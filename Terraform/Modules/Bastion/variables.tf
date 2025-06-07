variable "bastion_sg_id" {
  description = "Security Group ID for the Bastion Host"
}

variable "key_name" {
  description = "value of the key pair name"
}

variable "subnet_id" {
  description = "Subnet ID where the Bastion Host will be deployed"
}