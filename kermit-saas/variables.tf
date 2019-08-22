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
  default = "haKermit"
}

variable "cidr_block" {
  description = "Uber IP addressing for the Network"
  default = "80.0.0.0/16"
}

variable "cidr_public_kermit" {
  description = "Public 0.0 CIDR for externally accesible subnet"
  default = "80.0.0.0/24"
}

variable "cidr_priv_kermit" {
  description = "Private 0.2 block for shippable services"
  default = "80.0.100.0/24"
}

variable "cidr_builds_kermit" {
  description = "Private 200 block for builds"
  default = "80.0.200.0/24"
}

variable "inst_type" {
  default = "c4.large"
  description = "AWS Instance type for MS machines"
}

variable "inst_type_x" {
  default = "c4.xlarge"
  description = "AWS Instance type for onebox RC machine"
}

variable "inst_type_4x" {
  default = "c4.4xlarge"
  description = "AWS Instance type for large onebox RC machine"
}

variable "in_type_nat" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "t2.small"
  description = "AWS Instance type for consul server"
}

variable "in_type_jenkins" {
  //make sure it is compatible with AMI, not all AMIs allow all instance types "
  default = "t2.small"
  description = "AWS Instance type for Jenkins server"
}

variable "ami_us_east_1_ubuntu1604"{
  default = "ami-cd0f5cb6"
  description = "AWS AMI for us-east-1 Ubuntu 16.04"
}

variable "ami_us_east_1_centos7"{
  default = "ami-02eac2c0129f6376b"
  description = "AWS AMI for us-east-1 CentOS 7"
}
  
variable "ami_us_east_1_rhel7"{
  default = "ami-26ebbc5c"
  description = "AWS AMI for us-east-1 RHEL 7"
}  

# this is a special ami preconfigured to do NAT
variable "ami_us_east_1_nat"{
  default = "ami-d2ee95c5"
  description = "NAT AMI for us-east-1"
}

# this is a ACM certificate for domain *.shippable.com
variable "acm_cert_arn"{
  default = "arn:aws:acm:us-east-1:754160106182:certificate/968b6262-926d-4f99-a429-03f329fadfa5"
  description = "acm cert arn"
}
