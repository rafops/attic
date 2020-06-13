# PostgreSQL 

## Install OSX

```
brew install postgresql
```

## Initialize Database

```
initdb /usr/local/var/postgres -E utf8
```

## Start Database Daemon

```
postgres --single -D /usr/local/var/postgres postgres
```

## Create an User

```
createuser --createdb --login --superuser --no-password $USER
```

Connect to database:

```
psql postgres
```

## Locate Configuration

```
SHOW hba_file;
```

## Stop server

```
pg_ctl -D /usr/local/var/postgres stop
```

## List users

```
SELECT u.usename AS "Role name",
  CASE WHEN u.usesuper AND u.usecreatedb THEN CAST('superuser, create
database' AS pg_catalog.text)
       WHEN u.usesuper THEN CAST('superuser' AS pg_catalog.text)
       WHEN u.usecreatedb THEN CAST('create database' AS
pg_catalog.text)
       ELSE CAST('' AS pg_catalog.text)
  END AS "Attributes"
FROM pg_catalog.pg_user u
ORDER BY 1;
```