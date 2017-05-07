# AWS SES Mailer

```bash
export MAILER_TLD=example.com
export MAILER_DOMAIN=$MAILER_TLD
export MAILER_USER=no-reply
export AWS_REGION=us-east-1
export AWS_ACCOUNT_ID=…
```


## Domain Verification

```bash
hosted_zone_id=`aws route53 list-hosted-zones --output text --query "HostedZones[?Name=='$MAILER_TLD.'].Id" | cut -d '/' -f 3`
```

```bash
verification_token=`aws ses verify-domain-identity --domain $MAILER_DOMAIN --region $AWS_REGION | jq -r '.VerificationToken'`
```

```bash
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

```bash
aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch file://mailer-txt.json
```

```bash
aws ses get-identity-verification-attributes --identities $MAILER_DOMAIN --region $AWS_REGION
```

```bash
verification_tokens=`aws ses verify-domain-dkim --domain $MAILER_DOMAIN --region $AWS_REGION | jq -r '.DkimTokens[]'`
```

```bash
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

```bash
verify_dkim() {
    aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch file://mailer-dkim-$token.json
}

for token in `echo $verification_tokens` ; do verify_dkim ; done
```


```bash
aws ses get-identity-dkim-attributes --identities $MAILER_DOMAIN --region $AWS_REGION
```


## MX

```bash
cat >> mailer-mx.json <<-END
{
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "$MAILER_DOMAIN.",
        "Type": "MX",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "10 inbound-smtp.$AWS_REGION.amazonaws.com"
          }
        ]
      }
    }
  ]
}
END

```

```bash
aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch file://mailer-mx.json
```


## Receipt Rule

```bash
aws ses create-receipt-rule-set --rule-set-name default-rule-set --region $AWS_REGION
```

```bash
aws s3api create-bucket --acl private --bucket $MAILER_USER.$MAILER_DOMAIN --region $AWS_REGION
```

```bash
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

```bash
aws s3api put-bucket-policy --bucket $MAILER_USER.$MAILER_DOMAIN --policy file://mailer-policy.json
```

```bash
cat >> mailer-rule.json <<-END
{
  "Name": "$MAILER_USER",
  "Enabled": true,
  "TlsPolicy": "Optional",
  "Recipients": ["$MAILER_USER@$MAILER_DOMAIN"],
  "Actions": [
    {
      "S3Action": {
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

```bash
aws ses create-receipt-rule --rule-set-name default-rule-set --rule file://mailer-rule.json --region $AWS_REGION
```

```bash
aws ses set-active-receipt-rule-set --rule-set-name default-rule-set --region $AWS_REGION
```

