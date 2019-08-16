#========================== builds subnet ======================
resource "aws_subnet" "sn_builds_shipbits" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_builds_shipbits}"
  availability_zone = "${var.avl_zone}"
  tags {
    Name = "sn_builds_shipbits_${var.install_version}"
  }
}

# Routing table for builds subnet
resource "aws_route_table" "rt_ship_builds" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.inst_nat_shipbits.id}"
  }
  tags {
    Name = "rt_ship_builds_${var.install_version}"
  }
}

# Associate the routing table to builds subnet
resource "aws_route_table_association" "rt_assn_builds_shipbits" {
  subnet_id = "${aws_subnet.sn_builds_shipbits.id}"
  route_table_id = "${aws_route_table.rt_ship_builds.id}"
}

resource "aws_security_group" "sg_builds_shipbits" {
  name = "sg_builds_shipbits_${var.install_version}"
  description = "Builds Subnet security group for Kermit"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = [
      "${var.cidr_public_shipbits}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags {
    Name = "sg_builds_shipbits_${var.install_version}"
  }
}
