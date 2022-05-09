SELECT aws_s3.table_import_from_s3(
 'staging.title_principals', '', '(FORMAT csv, HEADER true, DELIMITER E''\t'')',
 '[S3_BUCKET_NAME]', '[S3_PREFIX]/title.principals.tsv.gz', '[REGION]'
);