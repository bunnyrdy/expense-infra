variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}
variable "common_tags" {
  default = {
    project = "expense"
    Environment = "dev"
    terraform = true
  }
}

variable "Domain" {
  default = "fortunechits.online"
}

variable "zone_id" {
    default = "Z09469641STVBK64UMI4H"
}