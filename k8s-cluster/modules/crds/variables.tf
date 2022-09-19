variable "crd_urls" {
  type        = list(string)
  description = "URLs that point to CRDs that need to be downloaded and applied to the cluster"
  validation {
    condition     = alltrue([for url in var.crd_urls : length(regexall("^https?://[a-z0-9./-?]*$", url)) > 0])
    error_message = "All url entries should be valid https urls."
  }
  default = []
}
