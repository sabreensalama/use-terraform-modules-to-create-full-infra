resource "aws_iam_role" "app_role" {
  name = var.role-name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = var.service
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "attch-to-role" {
  role = aws_iam_role.app_role.name
  count = length(var.managed_policy)
  policy_arn = var.managed_policy[count.index]
}