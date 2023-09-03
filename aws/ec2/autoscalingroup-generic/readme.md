# autoscalingroup-alb-nlb

Create a simple autoscaling group from a given AMI:

Deafult common policies included:
- SES
- S3
- Secrets
- EFS
  
ALB's sample self certificate:
- openssl genrsa 2048 &gt; &lt;Private key&gt;.pem
- openssl req -new -key &lt;Private key&gt;.pem -out &lt;Signing request&gt;.pem
- openssl x509 -req -days 365 -in &lt;Signing request&gt;.pem -signkey &lt;Private key&gt;.pem -out &lt;Certificate&gt;.crt
- aws acm import-certificate --profile &lt;User profile&gt; --certificate fileb://&lt;Certificate&gt;.crt --private-key fileb://&lt;Signing request&gt;.pem --region &lt;AWS region&gt;
