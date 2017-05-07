# Let's Encrypt

## Generate Certificates

Install `certbot`:

	brew install certbot

Set domain and subdomain:

	domain=example.com
	subdomain=secure.$domain

Generate certificate:

	sudo certbot certonly --manual --preferred-challenges dns --email admin@$domain -d $subdomain

Store the TXT record name and value:

	txt_name=_acme-challenge.$subdomain
	txt_value=…

Create a batch file:

```
cat >> $txt_name.json <<- END
{
    "Changes": [
        {
            "Action": "CREATE",
            "ResourceRecordSet": {
                "Name": "$txt_name.",
                "Type": "TXT",
                "TTL": 300,
                "ResourceRecords": [
                    {
                        "Value": "\"$txt_value\""
                    }
                ]
            }
        }
    ]
}
END
```

Get Route53 hosted zone ID:

	hosted_zone_id=`aws route53 list-hosted-zones --output text --query "HostedZones[?Name=='$domain.'].Id" | cut -d '/' -f 3`

Create a record set:

	aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch file://$txt_name.json

Wait until record is visible:

	dig txt $txt_name | grep ^$txt_name. | awk '{print $5}'

Press Enter to continue certbot validation. Certificates will be stored in `/etc/letsencrypt/live/$subdomain/`.

Delete TXT Record:

	sed -i.bak 's/CREATE/DELETE/' $txt_name.json
	aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch file://$txt_name.json


## Updating Certificates

### Heroku

Generate certificates and update Heroku:

	appname=appname
	sudo heroku certs:update /etc/letsencrypt/live/$subdomain/fullchain.pem /etc/letsencrypt/live/$subdomain/privkey.pem --app=$appname


### Amazon

Generate certificates and update CloudFront distribution:

	certificate_name=`echo $subdomain | sed s/\\\./-/g`-`date +%y%m%d`
	sudo aws iam upload-server-certificate --server-certificate-name $certificate_name \
		--certificate-body file:///etc/letsencrypt/live/$subdomain/cert.pem \
		--private-key file:///etc/letsencrypt/live/$subdomain/privkey.pem \
		--certificate-chain file:///etc/letsencrypt/live/$subdomain/chain.pem \
		--path /cloudfront/ 

#### CloudFront

Edit CloudFront distribution settings and change SSL certificate to `$certificate_name`.

Wait until distribution is updated and delete old certificate:

	aws iam delete-server-certificate --server-certificate-name secure-example-com-…

#### ELB

Edit Load Balancer Listener SSL certificate to `$certificate_name`.


## References

https://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html

https://docs.aws.amazon.com/AmazonS3/latest/dev/HowDoIWebsiteConfiguration.html
