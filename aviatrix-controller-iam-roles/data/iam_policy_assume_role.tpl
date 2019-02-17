{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "arn:aws:iam::*:role/aviatrix-*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "aws-marketplace:MeterUsage",
                "s3:GetBucketLocation"
            ],
            "Resource": "*"
        }
    ]
}