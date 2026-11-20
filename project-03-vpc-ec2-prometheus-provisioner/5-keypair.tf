resource "aws_key_pair" "terra-key" {
  key_name   = "terra-key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
