variable "redis_global_api_key" {
  description = "API key for RedisCloud access"
  type        = string
  sensitive   = true
}

variable "redis_global_secret_key" {
  description = "Secret key for RedisCloud access"
  type        = string
  sensitive   = true
}

variable "subscription_name" {
  description = "Name of the RedisCloud subscription"
  type        = string
}

variable "region_deployment_mappings" {
  description = "Mapping of regions to their CIDRs"
  type = map(string)
}

# List of Redis databases and their configuration
variable "redisusers" {
  description = "List of Redis databases and their configuration"
  type = list(object({
    name = object({
      prefix     = string
      descriptor = string
    })
    system   = string
    app      = string
    app_env  = string
  }))
}

# Per-database configuration
variable "database_configs" {
  description = "Configuration for each database with specific sizing and throughput"
  type = map(object({
    dataset_size_in_gb          = number
    read_operations_per_second  = number
    write_operations_per_second = number
  }))
}