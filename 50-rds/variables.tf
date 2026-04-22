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

variable "zoneid" {
    default = "Z09469641STVBK64UMI4H"
}

variable "domain_name" {
    default = "fortunechits.online"
}