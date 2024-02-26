module "vpn" {
  source = "../../terraform_modules/sg"
  project_name = var.project_name
  environment = var.environment
  vpc_id = data.aws_vpc.default.id
  sg_name = "vpn"
  sg_description = "SG for VPN"
}
module "mongodb" {
  source = "../../terraform_modules/sg"
  project_name = var.project_name
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "mongodb"
  sg_description = "SG for mongodb"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "redis" {
  source = "../../terraform_modules/sg"
  project_name = var.project_name
  environment = var.environment
  vpc_id = data.aws.aws_ssm_parameter.vpc_id.value
  sg_name = "redis"
  sg_description = "SG for redis"
}
module "mysql" {
  source = "../../terraform_modules/sg"
  project_name = var.project_name
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "mysql"
  sg_description = "SG for mysql"
}
module "rabbitmq" {
  source = "../../terraform_modules/sg"
  project_name = var.project_name
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "rabbitmq"
  sg_description = "SG for rabbitmq"
}
module "catalogue" {
  source = "../../terraform_modules/sg"
  project_name = var.project_name
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "catalogue"
  sg_description = "SG for Catalogue"
}

module "user" {
  source = "../../terraform_modules/sg"
  project_name = var.project_name
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "user"
  sg_description = "SG for user"
}
module "cart" {
  source = "../../terraform_modules/sg"
  project_name = var.project_name
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "cart"
  sg_description = "SG for cart"
}
module "shipping" {
  source = "../../terraform_modules/sg"
  project_name = var.project_name
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "shipping"
  sg_description = "SG for shipping"
}
module "payment" {
  source = "../../terraform_modules/sg"
  project_name = var.project_name
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "payment"
  sg_description = "SG for payment"
}
module "web" {
  source = "../../terraform_modules/sg"
  project_name = var.project_name
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "web"
  sg_description = "SG for web"
}
module "app_alb" {
  source = "../../terraform_modules/sg"
  project_name = var.project_name
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "app-alb"
  sg_description = "SG for App alb"
}
# Open VPN
resource "aws_security_group_rule" "vpn" {
  security_group_id = module.vpn.sg_id
  type = "ingress"
  to_port = 0
  from_port = 65535
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "mongodb_vpn" {
  source_security_group_id = module.vpn.sg_id
  type = "ingress"
  to_port = 22
  from_port = 22
  protocol = "tcp"
  security_group_id = module.mongodb.sg_id
}
# mongodb accepting connections from catalogue
resource "aws_security_group_rule" "mongodb_catalogue" {
    source_security_group_id = module.catalogue.sg_id
    type = "ingress"
    to_port = 27017
    from_port = 27017
    protocol = "tcp"
    security_group_id = module.mongodb.sg_id
}
# mongodb accepting connections from user
resource "aws_security_group_rule" "mongodb_user" {
  source_security_group_id = module.user.sg_id
  type = "ingress"
  to_port = 27017
  from_port = 27017
  protocol = "tcp"
  security_group_id = module.mongodb.sg_id
}

# redis accepting connections from user
resource "aws_security_group_rule" "redis_user" {
  source_security_group_id = module.user.sg_id
  type = "ingress"
  to_port = 6379
  from_port = 6379
  protocol = "tcp"
  security_group_id = module.redis.sg_id
}
# redis accepting connections from cart
resource "aws_security_group_rule" "redis_cart" {
  source_security_group_id = module.cart.sg_id
  type = "ingress"
  to_port = 6379
  from_port = 6379
  protocol = "tcp"
  security_group_id = module.redis.sg_id
}

resource "aws_security_group_rule" "mysql_vpn" {
  source_security_group_id = module.vpn.sg_id
  type = "ingress"
  to_port = 22
  from_port = 22
  protocol = "tcp"
  security_group_id = module.mysql.sg_id
}
resource "aws_security_group_rule" "mysql_shipping" {
  source_security_group_id = module.shipping.sg_id
  type = "ingress"
  to_port = 3306
  from_port = 3306
  protocol = "tcp"
  security_group_id = module.mysql.sg_id
}
resource "aws_security_group_rule" "rabbitmq_vpn" {
  source_security_group_id = module.vpn.sg_id
  type = "ingress"
  to_port = 22
  from_port = 22
  protocol = "tcp"
  security_group_id = module.rabbitmq.sg_id
}
resource "aws_security_group_rule" "rabbitmq_payment" {
  source_security_group_id = module.payment.sg_id
  type = "ingress"
  to_port = 5672
  from_port = 5672
  protocol = "tcp"
  security_group_id = module.rabbitmq.sg_id
}
resource "aws_security_group_rule" "catalogue_vpn" {
  source_security_group_id = module.vpn.sg.id
  type = "ingress"
  to_port = 22
  from_port = 22
  protocol = "tcp"
  security_group_id = module.catalogue.sg_id
}
# resource "aws_security_group_rule" "catalogue_web" {
#   source_security_group_id = module.web.sg_id
#   type = "ingress"
#   to_port = 8080
#   from_port = 8080
#   protocol = "tcp"
#   security_group_id = module.catalogue.sg_id
# }
# resource "aws_security_group_rule" "catalogue_cart" {
#   source_security_group_id = module.cart.sg_id
#   type = "ingress"
#   to_port = 8080
#   from_port = 8080
#   protocol = "tcp"
#   security_group_id = module.catalogue.sg_id
# }
resource "aws_security_group_rule" "catalogue_app_alb" {
  source_security_group_id = module.app_alb.sg_id
  type = "ingress"
  to_port = 8080
  from_port = 8080
  protocol = "tcp"
  security_group_id = module.catalogue.sg_id
}
resource "aws_security_group_rule" "user_vpn" {
  source_security_group_id = module.vpn.sg.id
  type = "ingress"
  to_port = 22
  from_port = 22
  protocol = "tcp"
  security_group_id = module.user.sg_id
}
resource "aws_security_group_rule" "user_web" {
  source_security_group_id = module.web.sg.id
  type = "ingress"
  to_port = 8080
  from_port = 8080
  protocol = "tcp"
  security_group_id = module.user.sg_id
}
resource "aws_security_group_rule" "user_payment" {
  source_security_group_id = module.payment.sg.id
  type = "ingress"
  to_port = 8080
  from_port = 8080
  protocol = "tcp"
  security_group_id = module.user.sg_id
}
resource "aws_security_group_rule" "cart_vpn" {
  source_security_group_id = module.vpn.sg.id
  type = "ingress"
  to_port = 22
  from_port = 22
  protocol = "tcp"
  security_group_id = module.cart.sg_id
}
resource "aws_security_group_rule" "cart_web" {
  source_security_group_id = module.web.sg.id
  type = "ingress"
  to_port = 8080
  from_port = 8080
  protocol = "tcp"
  security_group_id = module.cart.sg_id
}
resource "aws_security_group_rule" "cart_shipping" {
  source_security_group_id = module.shipping.sg.id
  type = "ingress"
  to_port = 8080
  from_port = 8080
  protocol = "tcp"
  security_group_id = module.cart.sg_id
}
resource "aws_security_group_rule" "cart_payment" {
  source_security_group_id = module.payment.sg.id
  type = "ingress"
  to_port = 8080
  from_port = 8080
  protocol = "tcp"
  security_group_id = module.cart.sg_id
}
resource "aws_security_group_rule" "shipping_vpn" {
  source_security_group_id = module.vpn.sg.id
  type = "ingress"
  to_port = 22
  from_port = 22
  protocol = "tcp"
  security_group_id = module.shipping.sg_id
}
resource "aws_security_group_rule" "shipping_web" {
  source_security_group_id = module.web.sg.id
  type = "ingress"
  to_port = 8080
  from_port = 8080
  protocol = "tcp"
  security_group_id = module.shipping.sg_id
}
resource "aws_security_group_rule" "payment_vpn" {
  source_security_group_id = module.vpn.sg.id
  type = "ingress"
  to_port = 22
  from_port = 22
  protocol = "tcp"
  security_group_id = module.payment.sg_id
}
resource "aws_security_group_rule" "payment_web" {
  source_security_group_id = module.web.sg.id
  type = "ingress"
  to_port = 8080
  from_port = 8080
  protocol = "tcp"
  security_group_id = module.payment.sg_id
}
resource "aws_security_group_rule" "web_vpn" {
  source_security_group_id = module.vpn.sg.id
  type = "ingress"
  to_port = 22
  from_port = 22
  protocol = "tcp"
  security_group_id = module.web.sg_id
}
resource "aws_security_group_rule" "web_internet" {
  cidr_blocks = [ "0.0.0.0/0" ]
  type = "ingress"
  to_port = 80
  from_port = 80
  protocol = "tcp"
  security_group_id = module.web.sg_id
}