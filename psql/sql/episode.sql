SELECT aws_s3.table_import_from_s3(
 'staging.episode', '', '(FORMAT csv, HEADER true, DELIMITER E''\t'')',
 '[S3_BUCKET_NAME]', '[S3_PREFIX]/title.episode.tsv.gz', '[REGION]'
);
