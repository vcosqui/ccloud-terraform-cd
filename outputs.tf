output "resource-ids" {
  value = <<-EOT
  Environment ID:   ${confluent_environment.dev.id}
  Kafka Cluster ID: ${confluent_kafka_cluster.standard.id}
  Kafka topic name: ${confluent_kafka_topic.pageviews.topic_name}
  EOT
  sensitive = true
}