module "srv" {
  source = "./modules"

  user_name   = var.user_name
  password    = var.password
  domain_name = var.domain_name
  tenant_name = var.tenant_name
  auth_url    = var.auth_url
  vpc_name    = var.vpc_name
  net_address = var.net_address
  public_key  = var.public_key
}
