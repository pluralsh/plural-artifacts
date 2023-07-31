resource "aws_iam_user" "postgres" {
  name = "plural-${var.cluster_name}-postgres"
}

resource "aws_iam_user_policy" "postgres-user-policy" {
  name   = "plural-${var.cluster_name}-postgres-user"
  user   = aws_iam_user.postgres.name
  policy = data.aws_iam_policy_document.postgres.json
}

resource "aws_iam_access_key" "postgres" {
  user = aws_iam_user.postgres.name
}

resource "kubernetes_secret" "example" {
  metadata {
    name = "postgres-user-auth"
    namespace = var.namespace
  }

  data = {
    ACCESS_KEY_ID = aws_iam_access_key.postgres.id
    SECRET_ACCESS_KEY = aws_iam_access_key.postgres.secret
  }

  depends_on = [
    kubernetes_namespace.postgres
  ]
}