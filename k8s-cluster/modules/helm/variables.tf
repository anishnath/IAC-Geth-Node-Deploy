variable "geth_namespace" {
  description = "(REQUIRED) The namespace where the Etherieum geth is deployed."
  type        = string
}

variable "domain_name" {
  description = "The base domain name for the vulcanize k8 load balancer."
  type        = string
}

variable "metrics_namespace" {
  description = "(REQUIRED) The namespace where metrics related controllers are deployed"
  default = "kube-prometheus-stack"
  type = string
}

variable "feature_flag_nginx" {
  description = "(OPTIONAL, DEFAULT = true) Disable this to maintain your own ingress solution."
  type        = bool
  default     = true
}

variable "nginx_namespace" {
  description = "(REQUIRED) The namespace where the ingress controller is deployed."
  type        = string
}

variable "nginx_ingress_controller_value_overrides" {
  description = "(OPTIONAL) The YML provided here will be merged over the platform default values for the nginx-ingress-controller Helm chart. See https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller for more information."
  type        = string
  default     = ""
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
