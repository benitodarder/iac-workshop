{
    "Statement": [
        {
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:${region}:${account_id}:log-group:/aws/lambda/${lambda_name}:*:*",
                "arn:aws:logs:${region}:${account_id}:log-group:/aws/lambda/${lambda_name}:*"
            ],
             "Sid": "LAMBDALOGSPOLICYCONFLUENTHELLOSWORLD"
        }
    ],
    "Version": "2012-10-17"
}
