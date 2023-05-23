/******************************************
  Secure web proxy.
 *****************************************/
module "secure_web_proxy" {
  source = "../gcp_secure_proxy"

  count = (var.mode == "hub" && var.enable_secure_web_proxy) ? 1 : 0

  environment_code                = var.environment_code
  project_id                      = var.project_id
  default_region                  = var.default_region
  prefix                          = var.prefix
  source_trusted_cidr_ranges      = var.internal_trusted_cidr_ranges
  subnetwork_name                 = local.private_subnets[0].subnet_name
  network_name                    = module.main.network_name

  depends_on = [
    module.main
  ]
}
