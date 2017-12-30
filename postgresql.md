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