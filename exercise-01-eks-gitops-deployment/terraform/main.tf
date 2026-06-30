# IAM Role for Service Accounts (IRSA) for External Secrets Operator

data "aws_iam_policy_document" "irsa_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:sub"
      values   = ["system:serviceaccount:default:external-secrets-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_external_secrets_role" {
  name               = "eks-external-secrets-role"
  assume_role_policy = data.aws_iam_policy_document.irsa_trust_policy.json

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_policy" "secrets_manager_access" {
  name        = "EKSExternalSecretsManagerPolicy"
  description = "Allows EKS External Secrets Operator to retrieve secrets from AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:*:123456789012:secret:prod/payment/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_secrets_attach" {
  role       = aws_iam_role.eks_external_secrets_role.name
  policy_arn = aws_iam_policy.secrets_manager_access.arn
}
