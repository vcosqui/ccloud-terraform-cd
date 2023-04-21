output "resource-ids" {
  value = <<-EOT
  Environment ID:   ${module.dev_environment.environment.id}
  Environment Name: ${module.dev_environment.environment.display_name}
  EOT
  sensitive = false
}