environment = {
  display_name = "dev-env"
}

service_account = {
  display_name = "service-account"
  role         = "CloudClusterAdmin"
}

cluster = {
  display_name = "automated"
  availability = "SINGLE_ZONE"
  cloud        = "GCP"
  region       = "us-central1"
  type         = "STANDARD"
}