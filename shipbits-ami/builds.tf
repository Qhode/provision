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
