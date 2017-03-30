output "app_user" {
  value = "${mysql_user.app_user.user}"
}
output "app_pass" {
  value = "${mysql_user.app_user.password}"
}
