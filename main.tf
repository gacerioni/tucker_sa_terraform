# Retrieve subscription information
data "rediscloud_active_active_subscription" "found_sub" {
  name = var.subscription_name
}

# Local variables to map region deployment and format database names
locals {
  region_deployment_mappings = var.region_deployment_mappings

  db_names = [ 
    for db_info in var.redisusers :
      replace("${db_info.name.prefix}-${db_info.system}-${db_info.name.descriptor}-${db_info.app}-${db_info.app_env}", "_", "")
  ]
}

# Fetch metadata of all databases under this subscription
data "rediscloud_active_active_subscription_database" "found_databases" {
  for_each = toset(local.db_names)
  subscription_id = data.rediscloud_active_active_subscription.found_sub.id
  name            = each.value
}

# Deploy databases to specific regions using their own custom sizing and throughput
resource "rediscloud_active_active_subscription_regions" "regions_resource" {
  subscription_id = data.rediscloud_active_active_subscription.found_sub.id
  delete_regions  = false

  dynamic "region" {
    for_each = local.region_deployment_mappings
    content {
      region                    = region.key
      networking_deployment_cidr = region.value

      dynamic "database" {
        for_each = data.rediscloud_active_active_subscription_database.found_databases
        content {
          database_id                       = database.value["db_id"]
          database_name                     = database.value["name"]  # Use the actual name from RedisCloud
          local_read_operations_per_second  = var.database_configs[database.key].read_operations_per_second
          local_write_operations_per_second = var.database_configs[database.key].write_operations_per_second
        }
      }
    }
  }

  timeouts {
    create = "2h"
    update = "2h"
    delete = "1h"
  }
}