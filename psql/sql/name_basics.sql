SELECT aws_s3.table_import_from_s3(
 'staging.name_basics', '', '(FORMAT csv, HEADER true, DELIMITER E''\t'')',
 '[S3_BUCKET_NAME]', '[S3_PREFIX]/name.basics.tsv.gz', '[REGION]'
);

