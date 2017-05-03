# AWS SES

```
export MAILER_TLD=example.com
export MAILER_DOMAIN=mailer.$MAILER_TLD
export AWS_REGION=us-east-1
```

```
aws s3api create-bucket --acl public-read --bucket $MAILER_DOMAIN
aws s3 website s3://$MAILER_DOMAIN/ --index-document index.html --error-document error.html
```

```
touch empty.html
aws s3 cp empty.html s3://$MAILER_DOMAIN/index.html
aws s3 cp empty.html s3://$MAILER_DOMAIN/error.html
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
    "Resource":["arn:aws:s3:::$MAILER_DOMAIN/*"]
  }]
}
END

```

```
aws s3api put-bucket-policy --bucket $MAILER_DOMAIN --policy file://website-policy.json
```

```
curl -vvv http://$MAILER_DOMAIN.s3-website-$AWS_REGION.amazonaws.com/index.html
```

```
hosted_zone_id=`aws route53 list-hosted-zones --output text --query "HostedZones[?Name=='$MAILER_TLD.'].Id" | cut -d '/' -f 3`
```

```
cat >> website-route.json <<-END
{
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "$MAILER_DOMAIN.",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$MAILER_DOMAIN.s3-website-$AWS_REGION.amazonaws.com"
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

```
verification_token=`aws ses verify-domain-identity --domain _amazonses.$MAILER_DOMAIN | jq -r '.VerificationToken'`
```

```
cat >> mailer-txt.json <<-END
{
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "_amazonses.$MAILER_DOMAIN.",
        "Type": "TXT",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "\"$verification_token\""
          }
        ]
      }
    }
  ]
}
END

```

```
aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch file://mailer-txt.json
```

```
aws ses get-identity-verification-attributes --identities $MAILER_DOMAIN --region $AWS_REGION
```

```
verification_tokens=`aws ses verify-domain-dkim --domain $MAILER_DOMAIN --region $AWS_REGION | jq -r '.DkimTokens[]'`
```

```
website_dkim() {
    cat >> mailer-dkim-$token.json <<-END
    {
      "Changes": [
        {
          "Action": "CREATE",
          "ResourceRecordSet": {
            "Name": "$token._domainkey.$MAILER_DOMAIN.",
            "Type": "CNAME",
            "TTL": 300,
            "ResourceRecords": [
              {
                "Value": "$token.dkim.amazonses.com"
              }
            ]
          }
        }
      ]
    }
END
}

for token in `echo $verification_tokens` ; do website_dkim ; done
```


```
verify_dkim() {
    aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch file://mailer-dkim-$token.json
}

for token in `echo $verification_tokens` ; do verify_dkim ; done
```


```
aws ses get-identity-dkim-attributes --identities $MAILER_DOMAIN --region us-east-1
```


## Receipt Rule

```
export MAILER_USER=no-reply
```

```
aws ses create-receipt-rule-set --rule-set-name default-rule-set --region $AWS_REGION
```

```
aws s3api create-bucket --acl private --bucket $MAILER_USER.$MAILER_DOMAIN
```

```
export AWS_ACCOUNT_ID=…
```

```
cat >> mailer-policy.json <<-END
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"GiveSESPermissionToWriteEmail",
    "Effect":"Allow",
    "Principal": {
      "Service":["ses.amazonaws.com"]
    },
    "Action":["s3:PutObject"],
    "Resource":["arn:aws:s3:::$MAILER_USER.$MAILER_DOMAIN/*"],
    "Condition": {
      "StringEquals": {
        "aws:Referer": "$AWS_ACCOUNT_ID"
      }
    }
  }]
}
END

```

```
aws s3api put-bucket-policy --bucket $MAILER_USER.$MAILER_DOMAIN --policy file://mailer-policy.json
```

```
sns_suffix=`echo $MAILER_DOMAIN | sed s/\\\./_/g`
sns_topic_name="$MAILER_USER""_$sns_suffix"
```

```
sns_topic_arn=`aws sns create-topic --name $sns_topic_name --region $AWS_REGION | jq -r '.TopicArn'`
```

```
cat >> mailer-rule.json <<-END
{
  "Name": "$MAILER_USER",
  "Enabled": true,
  "TlsPolicy": "Optional",
  "Recipients": ["$MAILER_USER@$MAILER_DOMAIN"],
  "Actions": [
    {
      "S3Action": {
        "TopicArn": "$sns_topic_arn",
        "BucketName": "$MAILER_USER.$MAILER_DOMAIN",
        "ObjectKeyPrefix": "",
        "KmsKeyArn": ""
      }
    }
  ],
  "ScanEnabled": true
}
END

```

```
aws ses create-receipt-rule --rule-set-name default-rule-set --rule file://mailer-rule.json --region $AWS_REGION
```

```
aws ses set-active-receipt-rule-set --rule-set-name default-rule-set --region $AWS_REGION
```
