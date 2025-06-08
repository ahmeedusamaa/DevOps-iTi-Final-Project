output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.Bastion.bastion_public_ip
}