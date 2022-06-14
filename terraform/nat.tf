# ========== EIP ==============
resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "eip"
  }
}

# ========== NAT configuration ==============
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name : "nat"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}