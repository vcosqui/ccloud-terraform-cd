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

# Confluent Cloud Environment
variable "environment" {
  type = object({
    display_name = string
  })
  description = "Confluent Cloud environment"
}

# Confluent Cloud Service Account
variable "service_account" {
  description = "Service Account and Role for cluster management."
  type = object({
    name = string
    role = string
  })
}

# Cluster definition
variable "cluster" {
  type = object({
    display_name = string
    availability = string
    cloud        = string
    region       = string
    type         = string
    cku          = optional(string)
    config       = optional(map(string))

  })
}