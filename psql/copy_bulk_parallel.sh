#!/bin/sh
host="[DATABASE_INSTANCE_HOSTNAME]"
db="imdb"

psql -h $host -p 5432 -d $db -U postgres -c "\i ./sql/title.sql" &
psql -h $host -p 5432 -d $db -U postgres -c "\i ./sql/crew.sql" &
psql -h $host -p 5432 -d $db -U postgres -c "\i ./sql/title_basics.sql" &
psql -h $host -p 5432 -d $db -U postgres -c "\i ./sql/episode.sql" &
psql -h $host -p 5432 -d $db -U postgres -c "\i ./sql/principals.sql" &
psql -h $host -p 5432 -d $db -U postgres -c "\i ./sql/ratings.sql" &
psql -h $host -p 5432 -d $db -U postgres -c "\i ./sql/name_basics.sql" &

wait
