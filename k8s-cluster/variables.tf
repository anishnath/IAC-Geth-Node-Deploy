variable "project_id" {
  description = "The project ID to deploy to"
}

variable "domain_name" {
  description = "A domain name that the system"
  type        = string
}

variable "feature_flag_nginx" {
  description = "(OPTIONAL, DEFAULT = true) This can be customized using the nginx_ingress_controller_values. Disable this to maintain your own ingress solution."
  type        = bool
  default     = true
}

variable "nginx_ingress_controller_value_overrides" {
  description = "(OPTIONAL) The YML provided here will be merged over the platform default values for the nginx-ingress-controller Helm chart. See https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller for more information."
  type        = string
  default     = ""
}

variable "crd_urls" {
  description = "List of publicly available urls that point to K8S CRD definitions. These will be installed on the cluster, without any backing controller implementation"
  type        = list(string)
  default     = []
}

variable "feature_flag_prometheus" {
  description = "(OPTIONAL, DEFAULT = true) Enable the platform Prometheus service. This can be customized using the kube_prometheus_stack_values. Disable this to maintain your own metric collection solution."
  type        = bool
  default     = true
}

variable "kube_prometheus_stack_value_overrides" {
  description = "(OPTIONAL) The YML provided here will be merged over the platform default values for the kube-prometheus-stack Helm chart. See https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml for more information."
  type        = string
  default     = ""
}
