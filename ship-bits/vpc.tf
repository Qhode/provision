# Define a vpc
resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = true
  tags {
    Name = "ship_bits-${var.install_version}"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "ig_ship_bits" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "ig_${var.install_version}"
  }
}

# make this routing table the main one
resource "aws_main_route_table_association" "rt_assn_builds_ship_bits" {
  vpc_id = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.rt_ship_builds.id}"
}
