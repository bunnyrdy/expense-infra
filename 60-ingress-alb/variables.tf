variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
    }
}


variable "zone_id" {
    default = "Z09469641STVBK64UMI4H"
}

variable "domain_name" {
    default = "fortunechits.online"
}