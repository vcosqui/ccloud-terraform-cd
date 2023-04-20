variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
  sensitive   = true
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "confluent_cloud_environment_name" {
  type        = string
  description = "Confluent Cloud environment name"
  default     = "environment"
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]{0,30}[a-zA-Z0-9]$", var.confluent_cloud_environment_name))
    error_message = "Invalid environment name, see https://docs.confluent.io/cloud/current/access-management/hierarchy/cloud-environments.html#add-an-environment for more information."
  }

}