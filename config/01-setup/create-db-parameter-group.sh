aws rds create-db-parameter-group \
   --db-parameter-group-name rds-postgres14-bulkload \
   --db-parameter-group-family postgres14 \
   --description "Optimized database parameters for bulk loading into Amazon RDS for PostgreSQL"
