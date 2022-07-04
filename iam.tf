#create the policy that will allow access to the S3 bucket
resource "aws_iam_policy" "bucket_policy" {
  name        = "my-bucket-policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
           "s3:*",
            "s3-object-lambda:*"
        ],
        "Resource": "*"
      }
    ]
  })
}

#IAM Role
resource "aws_iam_role" "some_role" {
  name = "my_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#Policy Attachment
resource "aws_iam_role_policy_attachment" "some_bucket_policy" {
  role       = aws_iam_role.some_role.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}

#aws_iam_instance_profile
resource "aws_iam_instance_profile" "some_profile" {
  name = "some-profile"
  role = aws_iam_role.some_role.name
}