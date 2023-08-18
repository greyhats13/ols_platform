# create cloud dns outputs from gcd module

output "security_gcm_ols_ssl_id" {
  value = module.gcm_ols.gcm_id
}

output "security_gcm_ols_ssl_certificate_id" {
  value = module.gcm_ols.gcm_certificate_id
}