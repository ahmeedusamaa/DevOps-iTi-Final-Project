# resource "aws_ecr_repository" "HendawyECRFront" {
#   name                 = var.FrontEnd_ECR_repository_name
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
#   lifecycle {
#     prevent_destroy = true
#   }
#   tags = {
#     Name = "HendawyECRFront"
#   }
# }

# resource "aws_ecr_repository" "HendawyECRBack" {
#   name                 = var.BackEnd_ECR_repository_name
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
#   lifecycle {
#     prevent_destroy = true
#   }
#   tags = {
#     Name = "HendawyECRBack"
#   }
# }
