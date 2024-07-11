resource "aws_iam_role" "this" {
  name               = "${var.prefix}-openvpn-server-role"
  assume_role_policy = file("${path.module}/iam/ec2_assume_policy.json")
}

resource "aws_iam_policy" "this" {
  policy = file("${path.module}/iam/ec2_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.prefix}-openvpn-server-role-profile"
  role = aws_iam_role.this.name
}