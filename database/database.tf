#
# RDS Resources
#  * chia_backup_db
#

resource "aws_db_instance" "db" {
  allocated_storage         = var.allocated_storage_size
  storage_type              = "gp2"
  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  instance_class            = var.instance_class
  name                      = var.db_name
  username                  = var.db_user_name
  password                  = var.db_password
  parameter_group_name      = var.parameter_group_name
  multi_az                  = var.multi_az
  publicly_accessible       = var.publicly_accessible
  vpc_security_group_ids    = var.security_groups
  final_snapshot_identifier = var.final_snapshot_id
  snapshot_identifier       = var.snapshot_id
  #skip_final_snapshot      = var.skip_final_snapshot
  tags = {
    Name = var.db_name
    application = var.application_tag
  }

  lifecycle {
    create_before_destroy = true
  }
}
