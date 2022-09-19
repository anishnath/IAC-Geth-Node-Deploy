locals {
  policy = templatefile("${path.module}/kube_geth_stack.yaml", {
    domain_name               = var.domain_name
  })
}

data "local_file" "kube_prometheus_stack" {
    filename = "${path.module}/kube_geth_stack.yaml"
}

resource "helm_release" "kube_prometheus_stack" {


  name             = "anish-platform"
  namespace        = var.geth_namespace
  repository       = "https://anish-private-repo:9000/helm-charts"
  chart            = "kube-geth-stack"
  version          = "0.0.0"
  create_namespace = true
  recreate_pods    = false
  cleanup_on_fail  = true
  skip_crds        = true


  values = [
    "${local.policy}",
    var.kube_prometheus_stack_value_overrides
  ]

  depends_on = [helm_release.nginx_ingress_controller]
}
