# main creds for AWS connection
variable "accessKey" {
  description = "AWS access key"
}

variable "secretKey" {
  description = "AWS secert access key"
}

variable "region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "avl_zone" {
  description = "availability zone used for the beta"
  default = "us-east-1b"
}

# this is a keyName for key pairs
variable "aws_key_name" {
  description = "Key Pair Name used to login to the box"
  default = "rc-us-east-1"
}

# this is a PEM key for key pairs
variable "aws_key_filename" {
  description = "Key Pair FileName used to login to the box"
  default = "rc-us-east-1.pem"
}

# all variables related to VPC
variable "install_version" {
  description = "version of the infra"
  default = "nat"
}

variable "cidr_block" {
  description = "Uber IP addressing for the Network"
  default = "80.0.0.0/16"
}

variable "cidr_public_ship_bits" {
  description = "Public 0.0 CIDR for externally accesible subnet"
  default = "80.0.0.0/24"
}

variable "cidr_builds_ship_bits" {
  description = "Private 200 block for builds"
  default = "80.0.200.0/24"
}

variable "in_type_nat" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "t2.small"
  description = "AWS Instance type for consul server"
}

# this is a special ami preconfigured to do NAT
variable "ami_us_east_1_nat"{
  default = "ami-d2ee95c5"
  description = "NAT AMI for us-east-1"
}
