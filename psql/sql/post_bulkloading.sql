CHECKPOINT;

VACUUM ANALYZE staging.title;
VACUUM ANALYZE staging.title_basics;
VACUUM ANALYZE staging.title_crew;
VACUUM ANALYZE staging.title_episode;
VACUUM ANALYZE staging.title_principals;
VACUUM ANALYZE staging.title_ratings;
VACUUM ANALYZE staging.name_basics;

begin;

ALTER TABLE staging.title SET (autovacuum_enabled = true);
ALTER TABLE staging.title_basics SET (autovacuum_enabled = true);
ALTER TABLE staging.title_crew SET (autovacuum_enabled = true);
ALTER TABLE staging.title_episode SET (autovacuum_enabled = true);
ALTER TABLE staging.title_principals SET (autovacuum_enabled = true);
ALTER TABLE staging.title_ratings SET (autovacuum_enabled = true);
ALTER TABLE staging.name_basics SET (autovacuum_enabled = true);

commit;

