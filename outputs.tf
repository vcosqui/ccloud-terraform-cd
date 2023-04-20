output "resource-ids" {
  value = <<-EOT
  Environment ID:   ${module.dev_environment.environment.id}
  Environment Name: ${module.dev_environment.environment.display_name}
  Kafka Cluster ID: ${confluent_kafka_cluster.standard.id}
  Kafka topic name: ${confluent_kafka_topic.pageviews.topic_name}
  EOT
  sensitive = false
}