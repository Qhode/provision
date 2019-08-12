#========================== builds subnet ======================
resource "aws_subnet" "sn_builds_ship_bits" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_builds_ship_bits}"
  availability_zone = "${var.avl_zone}"
  tags {
    Name = "sn_builds_ship_bits_${var.install_version}"
  }
}

# Routing table for builds subnet
resource "aws_route_table" "rt_ship_builds" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.inst_nat_ship_bits.id}"
  }
  tags {
    Name = "rt_ship_builds_${var.install_version}"
  }
}

# Associate the routing table to builds subnet
resource "aws_route_table_association" "rt_assn_builds_ship_bits" {
  subnet_id = "${aws_subnet.sn_builds_ship_bits.id}"
  route_table_id = "${aws_route_table.rt_ship_builds.id}"
}
