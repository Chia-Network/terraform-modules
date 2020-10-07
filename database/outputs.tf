output "db_user_name" {
value       = var.db_user_name
description = "the db user name"
}

output "db_password" {
value       = var.db_password
description = "the db password"
}

output "db_endpoint" {
value       = aws_db_instance.db.endpoint
description = "the db endpoint address:port"
}
