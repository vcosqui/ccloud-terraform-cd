terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.13.0"
    }
  }
}

resource "confluent_environment" "env" {
  display_name = var.environment.display_name
}