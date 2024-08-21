module "allow_eks_access_iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name          = "allow-eks-access"
  create_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

module "eks_admins_iam_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  role_name               = "eks-admin"
  create_role             = true
  role_requires_mfa       = false
  custom_role_policy_arns = [module.allow_eks_access_iam_policy.arn]
  trusted_role_arns       = ["arn:aws:iam::${module.vpc.vpc_owner_id}:root"]
}

module "allow_assume_eks_admins_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name = "allow-assume-eks-admin-iam-role"
  create_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"],
        Effect = "Allow",
        Resource = module.eks_admins_iam_role.iam_role_arn
      }
    ]
  })
}


data "aws_caller_identity" "current" {} # data.aws_caller_identity.current.account_id


resource "aws_iam_role" "eks-cluster-ebs-csi-driver-role" {
  name               = "AmazonEKS_EBS_CSI_DriverRole"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${module.eks.oidc_provider}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${module.eks.oidc_provider}:aud": "sts.amazonaws.com",
          "${module.eks.oidc_provider}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }
  ]
}
POLICY
}


data "aws_iam_role" "csi-driver-role" {
  name = aws_iam_role.eks-cluster-ebs-csi-driver-role.name
}

data "aws_iam_policy" "AmazonEBSCSIDriverPolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}


resource "aws_iam_role_policy_attachment" "eks-cluster-ebs-csi-driver-role-policy-attachement" {
  policy_arn = "${data.aws_iam_policy.AmazonEBSCSIDriverPolicy.arn}"
  role       = aws_iam_role.eks-cluster-ebs-csi-driver-role.name
}
