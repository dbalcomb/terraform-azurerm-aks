output "output" {
  description = "The cluster suffix"
  value       = data.http.main.body
}
