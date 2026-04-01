variable "region" {
  description = "Region AWS"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type instance EC2"
  type        = string
  default     = "t3.micro"
}

variable "projet" {
  description = "Nom du projet"
  type        = string
  default     = "leonel-devops"
}
