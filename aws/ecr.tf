variable "images" {
  type = "list"
  default = ["broker", "web", "worker"]
}

resource "aws_ecr_repository" "ecr" {
  count = "${length(var.images)}"
  name = "rdss-datavault/${element(var.images, count.index)}"
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  count = "${length(var.images)}"
  repository = "rdss-datavault/${element(var.images, count.index)}"

  # This really should delete all untagged images, but you cant' set countNumber less than 1
  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire old untagged images",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}