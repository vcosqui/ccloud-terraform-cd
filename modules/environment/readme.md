# Confluent Cloud Environment Module

## Purpose

Terraform module which creates environments in Confluent Cloud.

## Description

Confluent Cloud environments contain Kafka clusters and deployed components such as Connect, ksqlDB, and Schema
Registry.

For more detail, please
see [environments](https://docs.confluent.io/cloud/current/access-management/hierarchy/cloud-environments.html)
documentation.

## Usage Instructions

Copy and paste into your Terraform configuration, insert or update the
variables, and run `terraform init`:

```
module "dev_environment" {
  source      = "./modules/environment"
  environment = {
    display_name = "dev-env"
  }
}
```

## Preconditions and Assumptions

The credentials for Confluent Cloud must be provided

```
export TF_VAR_confluent_cloud_api_key="<CCLOUD_API_KEY>
export TF_VAR_confluent_cloud_api_secret="<CCLOUD_API_SECRET>
```

## Inputs

| Name             | Description                                                | Type   | Default | Required |
|------------------|------------------------------------------------------------|--------| ------- | -------- |
| environment_name | The environment name that will be displayed in the web UI. | string | - | yes |

## Outputs

| Name             | Description                 | Type                                                                               |
|------------------|-----------------------------|------------------------------------------------------------------------------------|
| environment | The environment definition. | <pre>object({<br/>  id = optional(string)<br/>  display_name = string<br/>})</pre> |

## Versions

| Version | Major changes |
| ------- | ------------- |
| 1     | Created module |
