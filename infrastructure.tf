module "srv" {
  source = "./modules"

  cloud       = "otc"
  
  public_key  = var.public_key
  net_address = var.net_address
  vpc_name    = var.vpc_name
}
