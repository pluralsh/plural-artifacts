resource "aws_iam_user" "cube" {
  name = "${var.cluster_name}-cube"
}

resource "aws_iam_access_key" "cube" {
  user = aws_iam_user.cube.name
}

resource "aws_iam_policy_attachment" "cube-user" {
  name = "${var.cluster_name}-cube-policy"
  users = [aws_iam_user.cube.name]
  policy_arn = module.s3_buckets.policy_arn
}
