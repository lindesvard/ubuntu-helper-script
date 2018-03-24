# ubuntu-helper-script

## Setup VPS

SSH into your machine

`curl -o setup-vps.sh https://raw.githubusercontent.com/lindesvard/ubuntu-helper-script/master/setup-vps.sh && sudo chmod +x setup-vps.sh`

Then run: `./setup-vps.sh`

## Create MySQL database with user

Before you can run this command you need to change **$MYSQL\_USER** and **$MYSQL\_PASSWORD** in create-db.sh.

This command will create a database and a user. Replace **{{db\_name}}**, **{{db\_user}}** and **{{db\_password}}** with your config.

`sh create-db.sh {{db_name}} {{db_user}} {{db_password}}`

#### Export database
`pg_dump -U difstart_user difstart_db --password >> db_dump.sql`

`pg_dump --data-only --inserts -U difstart_user difstart_db --password >> db_dump.sql`

#### Export database but only data no structure
`pg_dump --data-only -U difstart_user difstart_db --password >> db_dump_data.sql`

#### Import database
```
psql -U difstart_user difstart_cms --password < db_dump.sql
pg_restore -U difstart_user difstart_cms --password -F t -f 
```

#### Download file from remote server
`rsync -chavzP -e "ssh -p 22123" web@128.199.50.203:/var/lib/postgresql/db_dump.sql ./db_dump.sql`

#### Send file to remote server
`rsync -chavzP -e "ssh -p 22321" ./db_dump.sql web@192.81.223.173:/home/web/db_dump.sql`

#### Restart postgres
```
systemctl unmask postgresql
systemctl restart postgresql
```

