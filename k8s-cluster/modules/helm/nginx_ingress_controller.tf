data "local_file" "nginx_ingress_controller" {
    filename = "${path.module}/nginx_ingress_controller.yaml"
}

resource "helm_release" "nginx_ingress_controller" {
  count = var.feature_flag_nginx ? 1 : 0

  name             = "anish-platform"
  namespace        = var.nginx_namespace
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "nginx-ingress-controller"
  version          = "8.0.9"
  create_namespace = true
  recreate_pods    = true
  cleanup_on_fail  = true


  values = [
    data.local_file.nginx_ingress_controller.content,
    var.nginx_ingress_controller_value_overrides
  ]
}
