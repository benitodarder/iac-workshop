{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowGetSecretVAlue",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "arn:aws:secretsmanager:${region}:${account_id}:secret:*"
        }
    ]
}