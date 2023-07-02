{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowEFSDescribeSystems",
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:DescribeAccessPoints",
                "elasticfilesystem:DescribeFileSystems"
            ],
            "Resource": "arn:aws:elasticfilesystem:*:${account_id}:file-system/*"
        },
        {
            "Sid": "AllowEFSDescribe",
            "Effect": "Allow",
            "Action": "elasticfilesystem:DescribeAccountPreferences",
            "Resource": "*"
        }
    ]
}