# aws/rds/mysqluser - Create MySQL user with limited privileges
This module is used to create an application specific user with limited
privileges.

## What this does

 - Create user with given `app_user` username and `app_pass` password
 - Grant privileges on `database` with given `privileges`

## Required Inputs

 - `endpoint` - Database endpoint
 - `username` - Database user with privileges to create users, ex: `root`
 - `password` - Password for administrative user
 - `database` - Name of database
 - `app_user` - Username for new user to be created
 - `app_pass` - Password for new user to be created

### Optional Inputs

 - `privileges` - Default: `["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "DROP","INDEX", "ALTER", "CREATE TEMPORARY TABLES", "LOCK TABLES"]`

## Outputs

 - `app_user` - Username of user created
 - `app_pass` - Password of user created

## Example Usage

```hcl
module "mysqluser" {
  source = "github.com/silinternational/terraform-modules//aws/rds/mysqluser"
  endpoint = "${var.endpoint}"
  database = "${var.db_name}"
  username = "${var.db_root_user}"
  password = "${var.db_root_pass}"
  app_user = "${var.db_app_user}"
  app_pass = "${var.db_app_pass}"
}
```
