aws rds create-db-parameter-group \
   --db-parameter-group-name [DB_PARAMETER_GROUP_NAME] \
   --db-parameter-group-family postgres13 \
   --description "Optimized database parameters for bulk loading into Amazon RDS for PostgreSQL"
