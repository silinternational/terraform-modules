output "ipv4_cidrs" {
  value = split("\n", trimspace(data.http.cloudflare_ipv4.response_body))
}

output "ipv6_cidrs" {
  value = split("\n", trimspace(data.http.cloudflare_ipv6.response_body))
}
