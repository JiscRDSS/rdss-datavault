output "ecr_datavault_repository_urls" {
  value = "${aws_ecr_repository.ecr.*.repository_url}"
}
