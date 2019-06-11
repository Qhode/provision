#========================== 0.0 Subnet =============================

# Public subnet
resource "aws_subnet" "sn_public_kermit" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.cidr_public_kermit}"
  availability_zone = "${var.avl_zone}"
  map_public_ip_on_launch = true
  tags {
    Name = "sn-public_${var.install_version}"
  }
}

# Routing table for public subnet
resource "aws_route_table" "rt_public_kermit" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig_kermit.id}"
  }
  tags {
    Name = "rt-public_${var.install_version}"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "rt_assn_public_kermit" {
  subnet_id = "${aws_subnet.sn_public_kermit.id}"
  route_table_id = "${aws_route_table.rt_public_kermit.id}"
}

# Web Security group
resource "aws_security_group" "sg_public_kermit" {
  name = "sg_public_kermit_${var.install_version}"
  description = "Public traffic security group for kermit"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 5671
    to_port = 5671
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 15672
    to_port = 15672
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
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
    # allow all traffic to private SN
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "${var.cidr_priv_kermit}"]
  }
  tags {
    Name = "sg_public_kermit_${var.install_version}"
  }
}


# ----------
# GREEN ELBS
# ----------
//
//# MKTG Load balancer
//resource "aws_elb" "lb_mktg_kermit" {
//  name = "lb-mktg-kermit-${var.install_version}"
//  connection_draining = true
//  subnets = [
//    "${aws_subnet.sn_public_kermit.id}"]
//  security_groups = [
//    "${aws_security_group.sg_public_kermit.id}"]
//
//  listener {
//    lb_port = 443
//    lb_protocol = "ssl"
//    instance_port = 50002
//    instance_protocol = "tcp"
//    ssl_certificate_id = "${var.acm_cert_arn}"
//  }
//
//  health_check {
//    healthy_threshold = 2
//    unhealthy_threshold = 2
//    timeout = 3
//    target = "HTTP:50002/"
//    interval = 5
//  }
//
//  instances = [
//    "${aws_instance.inst_onebox_kermit.id}"
//  ]
//}

# WWW Load balancer
resource "aws_elb" "lb_www_kermit" {
  name = "lb-www-kermit-${var.install_version}"
  connection_draining = true
  subnets = [
    "${aws_subnet.sn_public_kermit.id}"]
  security_groups = [
    "${aws_security_group.sg_public_kermit.id}"]

  listener {
    lb_port = 443
    lb_protocol = "ssl"
    instance_port = 30001
    instance_protocol = "tcp"
    ssl_certificate_id = "${var.acm_cert_arn}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:30001/"
    interval = 5
  }

  instances = [
    "${aws_instance.inst_kermit_worker_c7.id}"
  ]
}

# API Load balancer
resource "aws_elb" "lb_api_kermit" {
  name = "lb-api-kermit-${var.install_version}"
  connection_draining = true
  subnets = [
    "${aws_subnet.sn_public_kermit.id}"]
  security_groups = [
    "${aws_security_group.sg_public_kermit.id}"]

  listener {
    lb_port = 443
    lb_protocol = "https"
    instance_port = 30000
    instance_protocol = "http"
    ssl_certificate_id = "${var.acm_cert_arn}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:30000/"
    interval = 5
  }

  instances = [
    "${aws_instance.inst_kermit_worker_c7.id}"
  ]
}
//
//# API INT ELB
//resource "aws_elb" "lb_api_int_kermit" {
//  name = "lb-api-int-kermit-${var.install_version}"
//  connection_draining = true
//  subnets = [
//    "${aws_subnet.sn_public_kermit.id}"]
//  security_groups = [
//    "${aws_security_group.sg_public_kermit.id}"]
//
//  listener {
//    lb_port = 443
//    lb_protocol = "https"
//    instance_port = 50004
//    instance_protocol = "http"
//    ssl_certificate_id = "${var.acm_cert_arn}"
//  }
//
//  health_check {
//    healthy_threshold = 2
//    unhealthy_threshold = 2
//    timeout = 3
//    target = "HTTP:50004/"
//    interval = 5
//  }
//
//  instances = [
//    "${aws_instance.inst_onebox_kermit.id}"
//  ]
//}
//
//#API CONSOLE ELB
//resource "aws_elb" "lb_api_con_kermit" {
//  name = "lb-api-con-kermit-${var.install_version}"
//  connection_draining = true
//  subnets = [
//    "${aws_subnet.sn_public_kermit.id}"]
//  security_groups = [
//    "${aws_security_group.sg_public_kermit.id}"]
//
//  listener {
//    lb_port = 443
//    lb_protocol = "https"
//    instance_port = 50005
//    instance_protocol = "http"
//    ssl_certificate_id = "${var.acm_cert_arn}"
//  }
//
//  health_check {
//    healthy_threshold = 2
//    unhealthy_threshold = 2
//    timeout = 3
//    target = "HTTP:50005/"
//    interval = 5
//  }
//
//  instances = [
//    "${aws_instance.inst_onebox_kermit.id}"
//  ]
//}

# MSG Load balancer
resource "aws_elb" "lb_msg_kermit" {
  name = "lb-msg-kermit-${var.install_version}"
  idle_timeout = 3600
  connection_draining = true
  connection_draining_timeout = 3600
  subnets = [
    "${aws_subnet.sn_public_kermit.id}"]
  security_groups = [
    "${aws_security_group.sg_public_kermit.id}"]

  listener {
    lb_port = 443
    lb_protocol = "https"
    instance_port = 30201
    instance_protocol = "http"
    ssl_certificate_id = "${var.acm_cert_arn}"
  }

  listener {
    lb_port = 5671
    lb_protocol = "ssl"
    instance_port = 30200
    instance_protocol = "tcp"
    ssl_certificate_id = "${var.acm_cert_arn}"
  }

  listener {
    lb_port = 15671
    lb_protocol = "https"
    instance_port = 30201
    instance_protocol = "http"
    ssl_certificate_id = "${var.acm_cert_arn}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:30201/"
    interval = 5
  }

  instances = [
    "${aws_instance.inst_kermit_worker_c7.id}"
  ]
}
