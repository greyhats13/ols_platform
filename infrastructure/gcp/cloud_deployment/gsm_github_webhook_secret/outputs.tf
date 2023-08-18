output "security_gsm_secret_version_data" {
  value = module.gsm_github_webhook_secret.gsm_secret_version_data
  sensitive = true
}