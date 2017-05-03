# AWS S3 Website

```
export WEBSITE_DOMAIN=example.com
export AWS_REGION=us-east-1
```

```
aws s3api create-bucket --acl public-read --bucket $WEBSITE_DOMAIN
aws s3 website s3://$WEBSITE_DOMAIN/ --index-document index.html --error-document error.html
```

```
touch empty.html
aws s3 cp empty.html s3://$WEBSITE_DOMAIN/index.html
aws s3 cp empty.html s3://$WEBSITE_DOMAIN/error.html
```

```
cat >> website-policy.json <<-END
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadGetObject",
    "Effect":"Allow",
    "Principal": "*",
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::$WEBSITE_DOMAIN/*"]
  }]
}
END

```

```
aws s3api put-bucket-policy --bucket $WEBSITE_DOMAIN --policy file://website-policy.json
```

```
curl -vvv http://$WEBSITE_DOMAIN.s3-website-$AWS_REGION.amazonaws.com/index.html
```

```
hosted_zone_id=`aws route53 list-hosted-zones --output text --query "HostedZones[?Name=='$WEBSITE_DOMAIN.'].Id" | cut -d '/' -f 3`
```

```
cat >> website-route.json <<-END
{
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "$WEBSITE_DOMAIN.",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$WEBSITE_DOMAIN.s3-website-$AWS_REGION.amazonaws.com"
          }
        ]
      }
    }
  ]
}
END

```

```
aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch file://website-route.json
```

