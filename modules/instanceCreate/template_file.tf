data "template_file" "userData" {
  # template = file("./userData.sh")
  template = file("./modules/instanceCreate/userData.sh")
  vars = {
    BUCKETNAME = var.s3_bucket
    DBUSER     = var.username
    DBPASS     = var.password
    DATABASE   = var.db_name
    DBPORT     = var.db_port
    DBHOST     = var.host_name
    PORT       = var.app_port
  }
}
