
resource "aws_iam_policy" "touca" {
  name_prefix = "touca"
  description = "policy for the plural admin touca"
  policy      = data.aws_iam_policy_document.touca.json
}

resource "aws_iam_user" "touca" {
  name = "${var.cluster_name}-touca"
}

resource "aws_iam_access_key" "touca" {
  user = aws_iam_user.touca.name
}

resource "aws_iam_policy_attachment" "touca-user" {
  name = "${var.cluster_name}-touca-policy"
  users = [aws_iam_user.touca.name]
  policy_arn = aws_iam_policy.touca.arn
}
