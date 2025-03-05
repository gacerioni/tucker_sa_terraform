terraform {
  required_providers {
    rediscloud = {
      source = "RedisLabs/rediscloud"
      version = "1.9.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "rediscloud" {
  # Configuration if we lose the VAULT SERVER
  #api_key = var.redis_global_api_key
  #secret_key = var.redis_global_secret_key

  # Config with Vault Server running and with the right expected schema.
  # I am afraid of conventions, but I guess this is the best approach for a DEMO.
  #api_key    = data.vault_generic_secret.redis_secrets.data["global_api_key"]
  #secret_key = data.vault_generic_secret.redis_secrets.data["global_secret_key"]
  api_key = var.redis_global_api_key
  secret_key = var.redis_global_secret_key

}
