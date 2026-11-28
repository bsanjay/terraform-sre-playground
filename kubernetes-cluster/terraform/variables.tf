variable "aws_region" {
  default = "us-west-2"
}

variable "key_name" {
  default = "k8s-lab"
}

variable "instance_type" {
  default = "t3.small"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "k8s-lab.pub"
}
