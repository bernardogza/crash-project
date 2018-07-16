variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "key_name" {
  default = "BernardoKey"
}

variable "public_key" {
  default = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuaxwkHILuEmHTluXzntHieSJYeWjMvp0sf5UeIFlUvIjU+myAU2lqstuawO8hhgblSVQCgED+hQeHR13ibzqiJK5sG+RA9q7gS7SII6JZMxXAs2qBPKuaRCVNcLWvZlfPEgpr5Rbm/ps6YIJDREPwbsNVys0YYeYjfW6mXNT8TzskWo95CdB5ctXZtBCHmonqjQbNo9I35RbVZUMcf6vc+lqOFmeYerZ62JgraRz62eR45Vi3fnh8W+i/nmBNo/xUQFicZVeRzxaCooH+y9PN7BJlnEh91TmRBfWJyhuYcqmAcfnfdabBzmCjbaqoJguufN/aCq8xp2E4HIePiIZAQIDAQAB"
}

variable "security_group" {
  default = "sg-07eb517a"
}

# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

# Create a web server
data "aws_security_group" "sec_group" {
  id = "${var.security_group}"
}

output "vpc_id" {
  value = "${data.aws_security_group.sec_group.vpc_id}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] #Canonical
}

resource "aws_instance" "web" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["${data.aws_security_group.sec_group.name}"]

  tags {
    name = "CrashCourse"
  }
}
