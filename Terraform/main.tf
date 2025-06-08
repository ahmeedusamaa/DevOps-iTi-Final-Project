module "Network" {
  source                = "./modules/Network"
  prefix                = local.prefix
  zone1                 = local.zone1
  zone2                 = local.zone2
  zone3                 = local.zone3
  eks_name              = local.eks_name
  vpc_cidr_block        = var.vpc_cidr_block
  Public_Subnets_count  = var.Public_Subnets_count
  Private_Subnets_count = var.Private_Subnets_count
}

module "IAM" {
  source            = "./modules/IAM"
  prefix            = local.prefix
  eks_name          = local.eks_name
  oidc_issuer       = module.EKS.oidc_provider_url
  oidc_provider_arn = module.OIDC.oidc_provider_arn
}

module "Keys" {
  source = "./modules/Keys"
}

module "SecGrp" {
  source         = "./modules/SecGrp"
  VPC_ID         = module.Network.vpc_id
  VPC_CIDR_BLOCK = module.Network.VPC_CIDR
  eks            = module.EKS.eks
  my_ip          = var.my_ip
}

module "EKS" {
  source                           = "./modules/EKS"
  prefix                           = local.prefix
  eks_name                         = local.eks_name
  eks_version                      = local.eks_version
  eks_role_arn                     = module.IAM.eks_role_arn
  Control_Plane_Policy_attatchment = module.IAM.Control_Plane_Policy_attatchment
  Private_Subnets_ID               = module.Network.private_subnet_ids
  Public_Subnets_ID                = module.Network.public_subnet_ids
  region                           = var.region
  ng_role_arn                      = module.IAM.ng_role_arn
  VPC_ID                           = module.Network.vpc_id
  eks_cluster_sg_id                = module.SecGrp.eks_cluster_sg_id
}

module "NodeGroup" {
  source                           = "./modules/NodeGroup"
  prefix                           = local.prefix
  eks_name                         = local.eks_name
  eks_version                      = local.eks_version
  zone1                            = local.zone1
  zone2                            = local.zone2
  Private_Subnets_ID               = module.Network.private_subnet_ids
  Public_Subnets_ID                = module.Network.public_subnet_ids
  ng_role_arn                      = module.IAM.ng_role_arn
  ng_worker_node_policy_attachment = module.IAM.ng_worker_node_policy_attachment
  ng_cni_policy_attachment         = module.IAM.ng_cni_policy_attachment
  ng_ecr_policy_attachment         = module.IAM.ng_ecr_policy_attachment
  Cluster_Name                     = module.EKS.cluster_name
  node_group_name                  = var.node_group_name
  Capacity_Type                    = var.Capacity_Type
  instance_type                    = var.instance_type
  key_name                         = module.Keys.Key_Name
  bastion_sg_id                    = module.SecGrp.bastion_sg_id
  depends_on                       = [module.EKS]
}

module "EBS" {
  source                = "./modules/EBS"
  ebs_csi_irsa_role_arn = module.IAM.ebs_csi_irsa_role_arn
  depends_on = [module.EKS, module.NodeGroup,
    module.IAM,
  null_resource.wait_for_k8s_ready]
}

module "ECR" {
  source                       = "./modules/ECR"
  FrontEnd_ECR_repository_name = var.FrontEnd_ECR_repository_name
  BackEnd_ECR_repository_name  = var.BackEnd_ECR_repository_name
}

module "Bastion" {
  source        = "./modules/Bastion"
  key_name      = module.Keys.Key_Name
  bastion_sg_id = module.SecGrp.bastion_sg_id
  subnet_id     = module.Network.public_subnet_ids[0]
}

module "OIDC" {
  source            = "./modules/OIDC"
  eks_name          = module.EKS.cluster_name
  oidc_provider_url = module.EKS.oidc_provider_url
  prefix            = local.prefix
  depends_on        = [module.EKS]
}

module "SecretsManager" {
  source = "./modules/SecretsManager"

  port = var.port

  mysql_host     = var.mysql_host
  mysql_port     = var.mysql_port
  mysql_user     = var.mysql_user
  mysql_password = var.mysql_password
  mysql_database = var.mysql_database

  redis_host     = var.redis_host
  redis_port     = var.redis_port
  redis_password = var.redis_password

  jenkins_admin_username = var.jenkins_admin_username
  jenkins_admin_password = var.jenkins_admin_password

  grafana_admin_user     = var.grafana_admin_user
  grafana_admin_password = var.grafana_admin_password
}


module "Route53" {
  source          = "./modules/Route53"
  nginx_lb_dns    = module.IngressController.nginx_lb_dns
  jenkins_host    = local.jenkins_host
  argocd_host     = local.argocd_host
  prometheus_host = local.prometheus_host
  grafana_host    = local.grafana_host
  domain_name     = var.domain_name
  sonarqube_host  = local.sonarqube_host
  AppHost         = local.app_host

}

module "Argo" {
  source                       = "./modules/Argo"
  region                       = local.region
  Account_ID                   = var.Account_ID
  ingress_hosts                = module.Route53.ingress_hosts
  argou_irsa_role_arn          = module.IAM.argou_irsa_role
  FrontEnd_ECR_repository_name = var.FrontEnd_ECR_repository_name
  BackEnd_ECR_repository_name  = var.BackEnd_ECR_repository_name
  App_Chart_Repo               = var.App_Chart_Repo
  ssh_private_key              = var.ssh_private_key
  depends_on = [module.EKS,
    module.NodeGroup,
    module.IAM,
    null_resource.wait_for_k8s_ready,
    module.ESO,
    module.CertManager,
  module.EBS]
}

module "CertManager" {
  source = "./modules/CertManager"
  email  = var.email
  depends_on = [module.EKS,
    module.NodeGroup,
    module.IAM,
  null_resource.wait_for_k8s_ready]
}

module "ESO" {
  source  = "./modules/ESO"
  region  = local.region
  eso_arn = module.IAM.eso_irsa_role_arn
  depends_on = [module.EKS,
    module.NodeGroup,
    module.IAM,
  null_resource.wait_for_k8s_ready]
}

module "IngressController" {
  source              = "./modules/IngressController"
  eks_core_dns        = module.NodeGroup.eks_core_dns
  nginx_ingress_sg_id = module.SecGrp.nginx_ingress_sg_id
  depends_on = [module.EKS,
    module.NodeGroup,
    module.IAM,
  null_resource.wait_for_k8s_ready]
}

module "Jenkins" {
  source                = "./modules/Jenkins"
  jenkins_irsa_role_arn = module.IAM.jenkins_irsa_role_arn
  ingress_hosts         = module.Route53.ingress_hosts
  kaniko_ecr_policy_arn = module.IAM.kaniko_ecr_policy_arn
  kaniko_irsa_role_name = module.IAM.kaniko_irsa_role_name
  kaniko_irsa_role      = module.IAM.kaniko_irsa_role
  kaniko_irsa_role_arn  = module.IAM.kaniko_irsa_role.arn
  depends_on = [module.EKS,
    module.NodeGroup,
    module.IAM,
    null_resource.wait_for_k8s_ready,
    module.ESO,
    module.CertManager,
  module.EBS]
}

module "Monitoring" {
  source        = "./modules/Monitoring"
  ingress_hosts = module.Route53.ingress_hosts
  depends_on = [module.EKS,
    module.NodeGroup,
    module.IAM,
    null_resource.wait_for_k8s_ready,
    module.ESO,
    module.CertManager,
  module.EBS]
}

module "SonarQube" {
  source        = "./modules/SonarQube"
  ingress_hosts = module.Route53.ingress_hosts
  depends_on = [module.EKS,
    module.NodeGroup,
    module.IAM,
    null_resource.wait_for_k8s_ready,
    module.CertManager,
  module.EBS]
}
