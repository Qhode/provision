#========================== inst subnet ======================
resource "aws_subnet" "sn_private_kermit" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_priv_kermit}"
  availability_zone = "${var.avl_zone}"
  tags {
    Name = "sn_private_kermit_${var.install_version}"
  }
}

# Routing table for private subnet
resource "aws_route_table" "rt_private_kermit" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.inst_nat_kermit.id}"
  }
  tags {
    Name = "rt_private_kermit_${var.install_version}"
  }
}

# Associate the routing table to private subnet
resource "aws_route_table_association" "rt_assn_private_kermit" {
  subnet_id = "${aws_subnet.sn_private_kermit.id}"
  route_table_id = "${aws_route_table.rt_private_kermit.id}"
}

resource "aws_security_group" "sg_private_kermit" {
  name = "sg_private_kermit_${var.install_version}"
  description = "Private Subnet security group for Kermit"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_kermit}"]
  }
  ingress {
    from_port = "30000"
    to_port = "30000"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_kermit}"]
  }
  ingress {
    from_port = "30001"
    to_port = "30001"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_kermit}"]
  }
  ingress {
    from_port = "50002"
    to_port = "50002"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_kermit}"]
  }
  ingress {
    from_port = "50003"
    to_port = "50003"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_kermit}"]
  }
  ingress {
    from_port = "50004"
    to_port = "50004"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_kermit}"]
  }
  ingress {
    from_port = "50005"
    to_port = "50005"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_kermit}"]
  }
  ingress {
    from_port = "30200"
    to_port = "30200"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_kermit}"]
  }
  ingress {
    from_port = "30201"
    to_port = "30201"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_kermit}"]
  }
  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_kermit}"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "${var.cidr_priv_kermit}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags {
    Name = "sg_private_kermit_${var.install_version}"
  }
}

# ---------------
# Shared file store
# ---------------
# resource "aws_efs_file_system" "efs_shared_kermit" {
#   creation_token = "efs_shared_kermit"
#
#   tags = {
#     Name = "efs_shared_kermit_${var.install_version}"
#   }
# }
#
# resource "aws_efs_mount_target" "mt_efs_shared_kermit" {
#   file_system_id = "${aws_efs_file_system.efs_shared_kermit.id}"
#   subnet_id = "${aws_subnet.sn_private_kermit.id}"
#   security_groups = [
#     "${aws_security_group.sg_private_kermit.id}"]
# }
#
# output "mt_efs_shared_kermit_dns" {
#   value = "${aws_efs_mount_target.mt_efs_shared_kermit.dns_name}"
# }

# ---------------
# One box instance
# ---------------

# instance kermit one box
resource "aws_instance" "inst_onebox_kermit" {
 ami = "${var.ami_us_east_1_ubuntu1604}"
 availability_zone = "${var.avl_zone}"
 instance_type = "${var.inst_type_x}"
 key_name = "${var.aws_key_name}"
 subnet_id = "${aws_subnet.sn_private_kermit.id}"

 vpc_security_group_ids = [
   "${aws_security_group.sg_private_kermit.id}"]

 root_block_device {
   volume_type = "gp2"
   volume_size = 100
   delete_on_termination = true
 }

 tags = {
   Name = "inst_onebox_kermit_${var.install_version}"
 }
}

output "inst_onebox_kermit_priv_ip" {
  value = "${aws_instance.inst_onebox_kermit.private_ip}"
}

# resource "aws_instance" "inst_kermit_master" {
#  ami = "${var.ami_us_east_1_ubuntu1604}"
#  availability_zone = "${var.avl_zone}"
#  instance_type = "${var.inst_type_x}"
#  key_name = "${var.aws_key_name}"
#  subnet_id = "${aws_subnet.sn_private_kermit.id}"
#
#  vpc_security_group_ids = [
#    "${aws_security_group.sg_private_kermit.id}"]
#
#  root_block_device {
#    volume_type = "gp2"
#    volume_size = 100
#    delete_on_termination = true
#  }
#
#  tags = {
#    Name = "inst_kermit_master_${var.install_version}"
#  }
# }
#
# output "inst_kermit_master_priv_ip" {
#   value = "${aws_instance.inst_onebox_kermit.private_ip}"
# }
#
# # instance kermit k8s worker node
# resource "aws_instance" "inst_kermit_worker" {
#  ami = "${var.ami_us_east_1_ubuntu1604}"
#  availability_zone = "${var.avl_zone}"
#  instance_type = "${var.inst_type_x}"
#  key_name = "${var.aws_key_name}"
#  subnet_id = "${aws_subnet.sn_private_kermit.id}"
#
#  vpc_security_group_ids = [
#    "${aws_security_group.sg_private_kermit.id}"]
#
#  root_block_device {
#    volume_type = "gp2"
#    volume_size = 100
#    delete_on_termination = true
#  }
#
#  tags = {
#    Name = "inst_kermit_worker_${var.install_version}"
#  }
# }
#
# output "inst_kermit_worker_priv_ip" {
#   value = "${aws_instance.inst_kermit_worker.private_ip}"
# }
