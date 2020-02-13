data "http" "main" {
  url = format("https://aks.dbalcomb.workers.dev/cluster/suffix/%s", var.input)
}
