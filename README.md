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
   --db-parameter-group-name [DB_PARAMETER_GROUP_NAME] \
   --db-parameter-group-family postgres13 \
   --description "Optimized database parameters for bulk loading into Amazon RDS for PostgreSQL"
```

Create json file `rds-postgresql13-bulkload.json` with optimized parameters.

```
{
    "DBParameterGroupName": "rds-postgresql-13-bulkload",
    "Parameters": [
		{
			"ParameterName": "maintenance_work_mem",
			"ParameterValue": "1048576",
			"ApplyMethod": "pending-reboot"
		},
		{
			"ParameterName": "max_wal_size",
			"ParameterValue": "4096",
			"ApplyMethod": "pending-reboot"
		},
		{
			"ParameterName": "checkpoint_timeout",
			"ParameterValue": "1800",
			"ApplyMethod": "pending-reboot"
		},
		{
			"ParameterName": "synchronous_commit",
			"ParameterValue": "off",
			"ApplyMethod": "pending-reboot"
		},
		{
			"ParameterName": "pglogical.synchronous_commit",
			"ParameterValue": "0",
			"ApplyMethod": "pending-reboot"
		},
		{
			"ParameterName": "autovacuum",
			"ParameterValue": "0",
			"ApplyMethod": "pending-reboot"
		}
	]
}
```

Modify the json file with parameter values to the optimized database parameter group.

```
aws rds modify-db-parameter-group \
   --db-parameter-group-name [DB_PARAMETER_GROUP_NAME] \
   --cli-input-json file://rds-postgresql13-bulkload.json
```

### 2. Apply optimized configurations prior to bulk loading

**CAUTION**: Only consider disabling MAZ and/or database backups if the operational risk profile of the database (as determined by the business) allows. Temporarily disabling MAZ and/or database backups increases performance of bulk loading, but incurs operational risks.

Disable MAZ
```
aws rds modify-db-instance --region [REGION] --db-instance-identifier [DB_INSTANCE_IDENTIFIER] --no-multi-az --apply-immediately
```

Disable backups
```
aws rds modify-db-instance --db-instance-identifier [DB_INSTANCE_IDENTIFIER] --backup-retention-period 0 --apply-immediately
```

Apply database parameter group optimized for bulk loading
```
aws rds modify-db-instance \
   --db-instance-identifier [DB_INSTANCE_IDENTIFIER] \
   --db-parameter-group [DB_PARAMETER_GROUP_NAME]
```
### 3. Return to normal configuration after bulk loading completes

Enable MAZ
```
aws rds modify-db-instance --region [REGION] --db-instance-identifier [DB_INSTANCE_IDENTIFIER] --multi-az --apply-immediately
```

Enable backups
```
aws rds modify-db-instance --db-instance-identifier [DB_INSTANCE_IDENTIFIER] --backup-retention-period [BACKUP_RETENTION_DAYS] --apply-immediately

```

Apply normal database parameter group
```
aws rds modify-db-instance \
   --db-instance-identifier [DB_INSTANCE_IDENTIFIER] \
   --db-parameter-group default.postgres13
```

## Performing bulk loading

The bash scripts provided execute psql commands against the Amazon RDS for PostgreSQL database. The script named `copy_bulk_sequential.sh` executes each psql command after the previous one finishes. The script named `copy_bulk_parallel.sh` executes all commands in parallel without waiting for the previous commands to complete.

Make scripts executable
```
chmod +x copy_bulk_sequential.sh
chmod +x copy_bulk_parallel.sh
```

Executing bulk load sequentially
```
./copy_bulk_sequential.sh
```

Executing bulk load in parallel
```
./copy_bulk_parallel.sh
```

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

