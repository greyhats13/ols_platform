output "bastion_private_key" {
  value     = tls_private_key.tls.private_key_pem
}