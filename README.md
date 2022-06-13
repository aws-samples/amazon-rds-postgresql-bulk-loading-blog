# Optimized bulk loading in Amazon RDS for PostgreSQL

The artifacts in this repository support the published blog: Optimized bulk loading in Amazon RDS for PostgreSQL. Refer to the blog for detailed instructions on setup and configuration for benchmarking.

## Setting up your testbench

To replicate the results presented in the blog you will need to complete the following steps:

- Create an EC2 instance to serve as a bastion host from which to execute psql commands.
- Create a multi-AZ Amazon RDS for PostgreSQL database instance with IAM authentication enabled.
- Follow this [guide](https://aws.amazon.com/premiumsupport/knowledge-center/rds-postgresql-connect-using-iam/) to create an IAM policy, an IAM role, and attach the role to Amazon RDS for PostgreSQL instance.
- Follow this [guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PostgreSQL.S3Import.html) to install the `aws_s3` extension, create an IAM role and policy that provides Amazon S3 permissions to execute the s3import function.
- Setup a [pgpass](https://www.postgresql.org/docs/13/libpq-pgpass.html) file with the proper credentials to allow the bash scripts to execute against the database instance.
- Create the `imdb` database, `staging` schema, and imdb tables using the provided DDL scripts.
- Download and stage the [IMDb public dataset](https://www.imdb.com/interfaces/) in an Amazon S3 bucket.
- Git clone this repo to the bastion host.

## Optimized bulk load configuration 

The folloiwng `cli` commands and `json` are provided in the `cli` folder.

### 1. Setup optimized database parameter group

First create a database parameter group and set parameters that are optimized for bulk loading.

```
aws rds create-db-parameter-group \
   --db-parameter-group-name rds-postgres14-bulkload \
   --db-parameter-group-family postgres14 \
   --description "Optimized database parameters for bulk loading into Amazon RDS for PostgreSQL"
```

Create json file `rds-postgresql14-bulkload.json` with optimized parameters.

```
{
    "DBParameterGroupName": "rds-postgresql14-bulkload",
    "Parameters": [
		{
			"ParameterName": "maintenance_work_mem",
			"ParameterValue": "1048576",
			"ApplyMethod": "immediate"
		},
		{
			"ParameterName": "max_wal_size",
			"ParameterValue": "4096",
			"ApplyMethod": "immediate"
		},
		{
			"ParameterName": "checkpoint_timeout",
			"ParameterValue": "1800",
			"ApplyMethod": "immediate"
		}
	]
}
```

Modify the json file with parameter values to the optimized database parameter group.

```
aws rds modify-db-parameter-group \
   --db-parameter-group-name rds-postgres14-bulkload \
   --cli-input-json file://rds-postgresql14-bulkload.json
```

### 2. Apply optimized configurations prior to bulk loading

Apply database parameter group optimized for bulk loading
```
aws rds modify-db-instance \
   --db-instance-identifier [DB_INSTANCE_IDENTIFIER] \
   --db-parameter-group rds-postgres14-bulkload
```
### 3. Return to normal configuration after bulk loading completes

Apply normal database parameter group
```
aws rds modify-db-instance \
   --db-instance-identifier [DB_INSTANCE_IDENTIFIER] \
   --db-parameter-group default.postgres14
```

## Performing bulk loading

The bash scripts provided execute psql commands against the Amazon RDS for PostgreSQL database. The script named `copy_bulk_sequential.sh` executes each psql command after the previous one finishes. The script named `copy_bulk_parallel.sh` executes all commands in parallel without waiting for the previous commands to complete. There are also a "pre" and "post" bulk loading scripts. The `pre_bulkloading.sh` script disables autovacuum at the table level. The `post_bulkloading.sh` script executes a checkpoint command, runs vacuum analyze on each of the target tables, then reenables autovacuum on each table.

Make scripts executable
```
cd psql
chmod +x pre_bulkloading.sh
chmod +x post_bulkloading.sh
chmod +x copy_bulk_sequential.sh
chmod +x copy_bulk_parallel.sh
```

Executing bulk load sequentially and report loading time
```
./pre_bulkloading.sh
time ./copy_bulk_sequential.sh
./post_bulkloading.sh
```

Executing bulk load in parallel and report loading time
```
./pre_bulkloading.sh
time ./copy_bulk_parallel.sh
./post_bulkloading.sh
```

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.
