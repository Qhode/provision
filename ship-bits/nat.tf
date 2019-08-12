
# NAT SG
resource "aws_security_group" "sg_nat_ship_bits" {
  name = "sg_nat_ship_bits_${var.install_version}"
  description = "Allow traffic to pass from the private subnet to the internet"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "${var.cidr_builds_ship_bits}"
    ]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_block}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "sg_nat_ship_bits_${var.install_version}"
  }
}

//this is a hack to get around double interpolation issues
//We need this in provisioner file block down below
resource "null_resource" "pemfile" {
  triggers{
    fileName ="${var.aws_key_filename}"
  }
}

# NAT Server
resource "aws_instance" "inst_nat_ship_bits" {
  ami = "${var.ami_us_east_1_nat}"
  availability_zone = "${var.avl_zone}"
  instance_type = "${var.in_type_nat}"
  key_name = "${var.aws_key_name}"

  subnet_id = "${aws_subnet.sn_public_ship_bits.id}"
  vpc_security_group_ids = [
    "${aws_security_group.sg_nat_ship_bits.id}"]

  provisioner "file" {
    source = "${var.aws_key_filename}"
    destination = "~/.ssh/${var.aws_key_filename}"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file(null_resource.pemfile.triggers.fileName)}"
      agent = true
    }
  }

  associate_public_ip_address = true
  source_dest_check = false

  tags = {
    Name = "nat_${var.install_version}"
  }
}

output "inst_nat_ship_bits_priv_ip" {
  value = "${ aws_instance.inst_nat_ship_bits.private_ip}"
}

output "inst_nat_ship_bits_pub_ip" {
  value = "${aws_instance.inst_nat_ship_bits.public_ip}"
}

# # Associate EIP, without this private SN wont work
resource "aws_eip" "eip_nat" {
  instance = "${aws_instance.inst_nat_ship_bits.id}"
  vpc = true
}
