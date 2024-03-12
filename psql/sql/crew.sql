begin;

SET LOCAL synchronous_commit TO OFF;

SELECT aws_s3.table_import_from_s3(
 'staging.crew', '', '(FORMAT csv, HEADER true, DELIMITER E''\t'')',
 '[S3_BUCKET_NAME]', '[S3_PRFEIX]/title.crew.tsv.gz', '[REGION]'
);

commit;
