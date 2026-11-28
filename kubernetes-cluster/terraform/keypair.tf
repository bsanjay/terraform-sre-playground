resource "aws_key_pair" "k8s-lab" {
  key_name   = "k8s-lab"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
