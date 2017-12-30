# AWS RDS

## Copy RDS snapshot between accounts

```
aws rds copy-db-snapshot --source-db-snapshot-identifier arn:aws:rds:us-west-1:123456789012:snapshot:db-2017-10-25-11-15 --target-db-snapshot-identifier db-2017-10-25-11-15 --region us-east-1
```
