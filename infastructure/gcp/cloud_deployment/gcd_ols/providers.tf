# create gcp provider
provider "google" {
  credentials = file("../../secrets/onlineshop-378118-e796d2c86870.json")
  project     = "onlineshop-378118"
  region      = "asia-southeast2"
}