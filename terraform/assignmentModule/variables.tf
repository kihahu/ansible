variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "ap-southeast-1"
  }

variable "instance_type" {
  default = "t2.medium"
  } 

variable "tagName" {
    type = "map"
  default = {
      "eu-west-1" = "tz-assignment-prd"
      "us-west-2" = "ke-assignment-prd"
      "ap-southeast-1" = "ph-assignment-prd"
    }
 }   

variable "ami" {
  type = "map"
  default = {
    us-west-2 = "ami-d732f0b7"
    eu-west-1 = "ami-ed82e39e"
    ap-southeast-1 ="ami-fb893398"
  }
}
  
variable "key_names" {
    type = "map"
	default = {
    "eu-west-1" = "master_eu_ireland"
    "us-west-2" = "Master"
    "ap-southeast-1" = "master_asia_pacific_singapore"
    }
}

variable "subnet_id" {
  type = "map"
  default = {
    us-west-2 = "subnet-0caa7c67"
    eu-west-1 = "subnet-b23c1ad6"
    ap-southeast-1 = "subnet-16dbb972"
  }
}
