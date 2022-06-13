begin;

SET LOCAL synchronous_commit TO OFF;

SELECT aws_s3.table_import_from_s3(
 'staging.titles', '', '(FORMAT csv, HEADER true, DELIMITER E''\t'')',
 '[S3_BUCKET_NAME]', '[S3_PREFIX]/title.akas.tsv.gz', '[REGION]'
);

commit;
