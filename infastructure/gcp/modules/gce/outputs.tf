output "bastion_private_key" {
  value     = tls_private_key.bastion_ssh.private_key_pem
  sensitive = true
}