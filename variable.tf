variable "my_instance_type" {
    type = string
 
}

variable "region" {
  
}

    variable "my_ami" {
      type = string
    }

    variable "my_aws_subnet" {
      type = string
    }
    variable "subnet_tags" {
        type = string
      
    }

    variable "my_subnet" {
          type = string
    }

    variable "private_subnet" {
      type = string
    }

    variable "my_aws_vpc" {
        type = string
    }


variable "my_vpc_name" {
  type = string
}

    variable "vpc_tags" {
      type = string
    }

    variable "my_private_ip_slaves" {
      type = list
      default = ["10.0.2.10", "10.0.2.20", "10.0.2.30"]
    }
    
   