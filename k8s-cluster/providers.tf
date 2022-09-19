data "google_client_config" "default" {}

provider "google" {
  version = "~> 3.16.0"
  region  = var.region
  project = var.project
}

provider "kubernetes" {
  host                   = var.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}
