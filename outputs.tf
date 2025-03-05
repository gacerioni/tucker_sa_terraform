output "existing_database_names" {
  value = {
    for db_name, db_data in data.rediscloud_active_active_subscription_database.found_databases :
    db_name => db_data.name
  }
}