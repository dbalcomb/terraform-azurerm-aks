data "external" "main" {
  program = ["${path.module}/scripts/suffix.sh"]
  query = {
    input = var.input
  }
}
