variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "sa-east-1"
  }
variable "tagName" {}
variable "elb_name" {}
variable "instance_type" {
  default = "t2.micro"
  } 

variable "ami" {
  type = "map"
  default = {
    sa-east-1 = "ami-839609ef"
    us-west-1 = "ami-4c03562c"
    eu-west-1 = "ami-bea5f3cd"
    ap-southeast-1 ="ami-63f15200"
  }
}
  
variable "key_names" {
    type = "map"
	default = {
	  "eu-west-1" = "master_eu_ireland"
      "us-west-1" = "master_ke"
      "sa-east-1" = "master_sao_paulo"
      "ap-southeast-1" = "master_asia_pacific_singapore"
    }
}
