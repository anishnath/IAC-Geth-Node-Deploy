locals {
  # not installing thanos rulers CRD
  prom_crds     = ["crd-servicemonitors.yaml"]
  prom_crd_urls = [for c in local.prom_crds : "https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-18.0.0/charts/kube-prometheus-stack/crds/${c}"]

  all_crd_urls = concat(var.crd_urls, local.prom_crd_urls)
}


resource "null_resource" "crd_manifests_from_urls" {
  for_each = toset(local.all_crd_urls)
  triggers = {
    crds = join(",", local.all_crd_urls)
  }
  provisioner "local-exec" {
    # we match the output see if the crd got created or if it already exists.
    # we consider both as success. To overcome partial failures.
    command = "kubectl create -f ${each.value} | awk '$0 ~ \"AlreadyExists|created$\"'"
  }
}
