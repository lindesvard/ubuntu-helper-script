# ubuntu-helper-script

## Setup VPS

SSH into your machine

`curl -o setup-vps.sh https://raw.githubusercontent.com/lindesvard/ubuntu-helper-script/master/setup-vps.sh && sudo chmod +x setup-vps.sh`

Then run: `./setup-vps.sh`

## Create MySQL database with user

Before you can run this command you need to change **$MYSQL\_USER** and **$MYSQL\_PASSWORD** in create-db.sh.

This command will create a database and a user. Replace **{{db\_name}}**, **{{db\_user}}** and **{{db\_password}}** with your config.

`sh create-db.sh {{db_name}} {{db_user}} {{db_password}}`
