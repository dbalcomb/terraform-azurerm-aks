output "output" {
  description = "The cluster suffix"
  value       = data.external.main.result.output
}
