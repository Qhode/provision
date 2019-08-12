#========================== 0.0 Subnet =============================

# Public subnet
resource "aws_subnet" "sn_public_ship_bits" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_public_ship_bits}"
  availability_zone = "${var.avl_zone}"
  map_public_ip_on_launch = true
  tags {
    Name = "sn-public_${var.install_version}"
  }
}

# Routing table for public subnet
resource "aws_route_table" "rt_public_ship_bits" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig_ship_bits.id}"
  }
  tags {
    Name = "rt-public_${var.install_version}"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "rt_assn_public_ship_bits" {
  subnet_id = "${aws_subnet.sn_public_ship_bits.id}"
  route_table_id = "${aws_route_table.rt_public_ship_bits.id}"
}
