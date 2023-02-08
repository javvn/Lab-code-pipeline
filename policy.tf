##################################################
# CODE DEPLOY
##################################################
resource "aws_iam_role" "deploy" {
  name = "${local.common_tags.Project}-DeployRole"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [{
      Effect : "Allow",
      Principal : {
        Service : "codedeploy.amazonaws.com"
      }
      Action : "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "deploy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.deploy.name

  depends_on = [aws_iam_role.deploy]
}

##################################################
# CODE PIPELINE
##################################################
resource "aws_iam_role" "pipeline" {
  name = "${local.common_tags.Project}-PipelineRole"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [{
      Effect : "Allow",
      Principal : {
        Service : "codepipeline.amazonaws.com"
      },
      Action : "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "pipeline" {
  name = "PipelineAccess"
  role = aws_iam_role.pipeline.id
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : ["iam:PassRole"],
        "Resource" : "*",
        "Effect" : "Allow",
        "Condition" : {
          "StringEqualsIfExists" : {
            "iam:PassedToService" : [
              "ec2.amazonaws.com",
            ]
          }
        }
      },
      {
        "Action" : [
          "codecommit:CancelUploadArchive",
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:GetRepository",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:UploadArchive"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "codedeploy:CreateDeployment",
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:RegisterApplicationRevision"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "elasticbeanstalk:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "cloudwatch:*",
          "s3:*",
          "sns:*",
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObjectAcl",
          "s3:PutObject"
        ],
        "Resource" : [
          aws_s3_bucket.pipeline.arn,
          "${aws_s3_bucket.pipeline.arn}/*"
        ]
      }
    ],
    "Version" : "2012-10-17"
  })
}

##################################################
# EC2
##################################################
resource "aws_iam_role" "ec2" {
  name = "${local.common_tags.Project}-EC2Role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

resource "aws_iam_instance_profile" "ec2" {
  name = aws_iam_role.ec2.name
  role = aws_iam_role.ec2.name
}