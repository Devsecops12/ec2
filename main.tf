resource "aws_instance" "my-instance" {
  count         = var.instance_count
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.terraform-demo.key_name
  

  tags = {
     Name = var.instance_name
     component = var.component
  }
}
