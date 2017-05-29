variable "vpc_id"     {}
variable "ami"        {}
variable "public_key" {}
variable "db"         {}
variable "db_usr"     {}
variable "db_pwd"     {}
variable "region"     {}
variable "profile"    {}

provider "aws" {
    region  = "${var.region}"
    profile = "${var.profile}"
}

resource "aws_security_group" "default" {
  name   = "acme_rds_sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "rds_sg"
  }
}

resource "aws_subnet" "subnet_0" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "172.31.150.0/24"
  availability_zone = "${var.region}a"

  tags {
    Name = "acme_subnet_0"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "acme_public_key"
  public_key = "${file(var.public_key)}"
}

resource "aws_instance" "legacy" {
  instance_type          = "t2.micro"
  ami                    = "${var.ami}"
  key_name               = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id              = "${aws_subnet.subnet_0.id}"
  connection {
    user = "ubuntu"
  }
}

resource "aws_eip" "default" {
  instance = "${aws_instance.legacy.id}"
  vpc      = true
}

output "instance_address" {
  value = "${aws_eip.default.public_ip}"
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "172.31.151.0/24"
  availability_zone = "${var.region}a"

  tags {
    Name = "acme_subnet_1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "172.31.152.0/24"
  availability_zone = "${var.region}b"

  tags {
    Name = "acme_subnet_2"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "acme_subnet_group"
  subnet_ids = ["${aws_subnet.subnet_1.id}", "${aws_subnet.subnet_2.id}"]
}

resource "aws_db_instance" "default" {
  depends_on             = ["aws_security_group.default"]
  allocated_storage      = 10
  identifier             = "acme-rds"
  engine                 = "postgres"
  engine_version         = "9.5.6"
  instance_class         = "db.t2.micro"
  name                   = "${var.db}"
  username               = "${var.db_usr}"
  password               = "${var.db_pwd}"
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.default.id}"
}

output "db_instance_address" {
  value = "${aws_db_instance.default.address}"
}
