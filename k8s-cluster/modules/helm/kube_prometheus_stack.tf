locals {
  policy = templatefile("${path.module}/kube_prometheus_stack.yaml", {
    domain_name               = var.domain_name
    feature_flag_prometheus   = var.feature_flag_prometheus
  })
}

data "local_file" "kube_prometheus_stack" {
    filename = "${path.module}/kube_prometheus_stack.yaml"
}

resource "helm_release" "kube_prometheus_stack" {
  count = var.feature_flag_prometheus  ? 1 : 0

  name             = "anish-platform"
  namespace        = var.metrics_namespace
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "34.6.0"
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
