#!/bin/bash

USER=$1
DATABASE_ONE=$2
DATABASE_TWO=$3



if [ "$USER" = "" ]; then
	echo "Missing db user as first argument"
	exit
fi

if [ "$DATABASE_ONE" = "" ]; then
	echo "Missing source database name as second argument"
	exit
fi


if [ "$DATABASE_TWO" = "" ]; then
	echo "Missing destination database name as thrid argument"
	exit
fi

echo "Syncing..."

pg_dump -Fc $DATABASE_ONE > /var/lib/postgresql/prod_dump.db

# createdb --owner=$USER test_blaranderna_forum

pg_restore  --clean --role=$USER --dbname $DATABASE_TWO /var/lib/postgresql/prod_dump.db
