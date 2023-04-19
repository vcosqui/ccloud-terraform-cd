terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.13.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

resource "confluent_environment" "dev" {
  display_name = "automated"
}

resource "confluent_kafka_cluster" "standard" {
  display_name = "automated"
  availability = "SINGLE_ZONE"
  cloud        = "GCP"
  region       = "us-central1"
  dedicated {
    cku = 1
  }
  environment {
    id = confluent_environment.dev.id
  }
}

resource "confluent_service_account" "app-manager" {
  display_name = "app-manager-automated"
  description  = "Service account to manage 'automated' Kafka cluster"
}

resource "confluent_role_binding" "app-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.app-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.standard.rbac_crn
}

resource "confluent_api_key" "app-manager-kafka-api-key" {
  display_name = "app-manager-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-manager' service account"
  owner {
    id          = confluent_service_account.app-manager.id
    api_version = confluent_service_account.app-manager.api_version
    kind        = confluent_service_account.app-manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.standard.id
    api_version = confluent_kafka_cluster.standard.api_version
    kind        = confluent_kafka_cluster.standard.kind

    environment {
      id = confluent_environment.dev.id
    }
  }
  depends_on = [
    confluent_role_binding.app-manager-kafka-cluster-admin
  ]
}

resource "confluent_kafka_topic" "pageviews" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  topic_name       = "pageviews"
  partitions_count = 6
  rest_endpoint    = confluent_kafka_cluster.standard.rest_endpoint
  config           = {
    "retention.ms"                      = "-1"
    "cleanup.policy"                    = "delete"
  }
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_topic" "connect-cp-kafka-connect-offset" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  topic_name       = "default.connect-offsets"
  partitions_count = 6
  rest_endpoint    = confluent_kafka_cluster.standard.rest_endpoint
  config           = {
    "retention.ms"                      = "-1"
    "cleanup.policy"                    = "compact"
  }
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_topic" "connect-cp-kafka-connect-status" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  topic_name       = "default.connect-status"
  partitions_count = 6
  rest_endpoint    = confluent_kafka_cluster.standard.rest_endpoint
  config           = {
    "retention.ms"                      = "-1"
    "cleanup.policy"                    = "compact"
  }
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_topic" "connect-cp-kafka-connect-config" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  topic_name       = "default.connect-configs"
  partitions_count = 1
  rest_endpoint    = confluent_kafka_cluster.standard.rest_endpoint
  config           = {
    "retention.ms"                      = "-1"
    "cleanup.policy"                    = "compact"
  }
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}


## create producer account and key and grant permissions on topic
resource "confluent_service_account" "app-producer" {
  display_name = "app-producer-automated"
  description  = "account to produce to 'pageviews' topic"
}

resource "confluent_api_key" "app-producer-kafka-api-key-v2" {
  display_name = "app-producer-automated-kafka-api-key-v2"
  description  = "Kafka API Key that is owned by 'app-producer-automated' service account"
  owner {
    id          = confluent_service_account.app-producer.id
    api_version = confluent_service_account.app-producer.api_version
    kind        = confluent_service_account.app-producer.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.standard.id
    api_version = confluent_kafka_cluster.standard.api_version
    kind        = confluent_kafka_cluster.standard.kind

    environment {
      id = confluent_environment.dev.id
    }
  }
}

resource "confluent_role_binding" "app-producer-developer-pageviews-write-to-topic" {
  principal   = "User:${confluent_service_account.app-producer.id}"
  role_name   = "ResourceOwner"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/topic=${confluent_kafka_topic.pageviews.topic_name}"
}