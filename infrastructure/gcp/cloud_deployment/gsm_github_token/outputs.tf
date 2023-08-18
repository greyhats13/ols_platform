output "security_gsm_secret_version_data" {
  value = module.gsm_github_token.gsm_secret_version_data
  sensitive = true
}