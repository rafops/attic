# PostgreSQL 

## Install OSX

```
brew install postgresql
postgres --single -D /usr/local/var/postgres postgres
```

```
CREATE USER myuser WITH PASSWORD 'password' SUPERUSER;
CREATE USER playground WITH PASSWORD 'playground' SUPERUSER;
```

Control+d to exit.

Start server:

```
pg_ctl -D /usr/local/var/postgres start
```

Connect to database:

```
psql postgres
```

Locate configuration file:

```
SHOW hba_file;
```

Create additional user for application:

```
createuser -d myappusr
```

Stop server:

```
pg_ctl -D /usr/local/var/postgres stop
```