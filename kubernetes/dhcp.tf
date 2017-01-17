resource "aws_vpc_dhcp_options" "dhcp_opts" {
    domain_name = "${var.domain_name}"
    # Check
    domain_name_servers = ["AmazonProvidedDNS"]
    tags {
      Name = "${var.prefix}-${var.tags["dhcp"]}"
      Owner = "${var.owner}"
    }
}

resource "aws_vpc_dhcp_options_association" "dhcp_assoc" {
    vpc_id = "${aws_vpc.vpc.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.dhcp_opts.id}"
}
