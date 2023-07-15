# ec2-instance-elb

Create a simple EC2 from a given AMI exposing it using a classic balancer (Elastik Load Balancer)

Deafult common policies included:
- SES
- S3
- Secrets
- EFS
  
Currently three versions available:

- axislab01: from AMI base SSH exposed to given list of CIDR's
  + SSH exposed on port 2222
- configureStartService: from AMI base generates a sample 'hello world' HTTP with current IP.
  + SSH exposed to given list of CIDR's on port 2222
  + Python http.server on port 8000 exposed to given list of CIDR's
