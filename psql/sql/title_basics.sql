begin;

SET LOCAL synchronous_commit TO OFF;

SELECT aws_s3.table_import_from_s3(
 'staging.title_basics', '', '(FORMAT csv, HEADER true, DELIMITER E''\t'')',
 '[S3_BUCKET_NAME]', '[S3_PREFIX]/title.basics.tsv.gz', '[REGION]'
);

commit;
