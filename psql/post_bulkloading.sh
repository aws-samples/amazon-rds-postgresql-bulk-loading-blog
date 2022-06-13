#!/bin/sh
host="[DATABASE_INSTANCE_HOSTNAME]"
db="imdb"

psql -h $host -p 5432 -d $db -U postgres -c "\i ./sql/post_bulkloading.sql"
