variable "environment" {
  type = object({
    id           = optional(string)
    display_name = string
  })
}