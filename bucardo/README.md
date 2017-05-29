# Bucardo

## Cloud Setup

```bash
export TF_VAR_region=ca-central-1
export TF_VAR_profile=default
export TF_VAR_vpc_id=`aws ec2 describe-vpcs --region $TF_VAR_region --profile $TF_VAR_profile | jq -r '.Vpcs[0].VpcId'`

# https://cloud-images.ubuntu.com/locator/ec2/
export TF_VAR_ami='ami-e273cf86'
export TF_VAR_public_key=$HOME/.ssh/id_rsa.pub

export TF_VAR_db='acmedb'
export TF_VAR_db_usr='acmeusr'
export TF_VAR_db_pwd='AcmePwd123'
```

```bash
terraform plan -out plan.terraform
terraform apply plan.terraform
```

Connect to EC2:

```
ssh ubuntu@instance_address
```

Install PostgreSQL server:

```
sudo apt-get install postgresql-9.5 postgresql-plperl-9.5
```

Test connection with RDS:

```bash
psql -U acmeusr -W -h db_instance_address -d acmedb
```


## Installing Bucardo

```bash
mkdir bucardo
cd bucardo
curl -L -O https://github.com/bucardo/bucardo/archive/5.4.1.tar.gz
tar zxvf 5.4.1.tar.gz
cd bucardo-5.4.1
```

Installing pre-requisites:

```bash
sudo apt-get install build-essential
sudo apt-get install libdbi-perl libdbd-pg-perl libdbix-safe-perl
sudo apt-get install libboolean-perl libencode-locale-perl
```

Installing Bucardo:

```bash
perl Makefile.PL
make
sudo make install
cd ..
```

Setup Bucardo database (password should be `bucardo`):

```bash
sudo su - postgres -c "createuser -s -P bucardo"
sudo su - postgres -c "createdb -O bucardo bucardo"
echo "127.0.0.1:5432:bucardo:bucardo:bucardo" > $HOME/.pgpass
chmod 0400 $HOME/.pgpass
```

```bash
cat > $HOME/.bucardorc <<EOL
dbhost=127.0.0.1  
dbname=bucardo  
dbport=5432  
dbuser=bucardo  
EOL
```

```
bucardo install
```

Change User to `bucardo`, PID directory to `/home/ubuntu/bucardo`, and Proceed.

Migrate schema:

```
pg_dump -F c -s -U acmeusr -W -h 127.0.0.1 -n s1 -n s2 -n … -d acmedb | \
  pg_restore -F c -U acmeusr -W -h db_instance_address -d acmedb
```

Add source database:

```
bucardo add db acme_source user=acmeusr pass=AcmePwd543 host=127.0.0.1 dbname=acmedb
```

Add target database:

```
bucardo add db acme_target user=acmeusr pass=AcmePwd543 host=db_instance_address dbname=acmedb conn="sslmode=require-all"
```

Add tables/sequences and create relgroup:

```
bucardo add table s1.t1 db=acme_source relgroup=acme_relgroup
bucardo add table s2.t1 db=acme_source relgroup=acme_relgroup
…
bucardo add sequence …
…
```

Create dbgroup:

```
bucardo add dbgroup acme_dbgroup acme_source:source acme_target:target
```

Add sync:

```
bucardo add sync acme_sync relgroup=acme_relgroup dbs=acme_dbgroup onetimecopy=0 autokick=0
```

Validate:

```
bucardo validate acme_sync
```

Migrate data:

```
pg_dump -F c -a --disable-triggers -U acmeusr -W -h 127.0.0.1 -n s1 -n s2 -d acmedb | \
  pg_restore -F c --disable-triggers -U acmeusr -W -h db_instance_address -d acmedb
```

Insert additional data.

Enable autokick:

```
bucardo update sync acme_sync autokick=1
```

Start:

```
sudo mkdir -p /var/log/bucardo
sudo chown $USER /var/log/bucardo
bucardo start
```

Check status:

```
bucardo status acme_sync
```


## Cleanup

```bash
bucardo stop
rm fullstopbucardo
rm bucardo.restart.reason.*
bucardo remove sync acme_sync
bucardo remove dbgroup acme_dbgroup
bucardo remove relgroup acme_relgroup
bucardo remove table s1.t1
bucardo remove table s2.t1
…
bucardo remove sequence …
…
bucardo remove db acme_target
bucardo remove db acme_source
sudo su - postgres -c "dropdb bucardo"

terraform plan -out destroy.terraform -destroy
terraform apply destroy.terraform
```
