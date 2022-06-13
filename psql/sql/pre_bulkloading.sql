begin;

ALTER TABLE staging.title SET (autovacuum_enabled = false);
ALTER TABLE staging.title_crew SET (autovacuum_enabled = false);
ALTER TABLE staging.title_basics SET (autovacuum_enabled = false);
ALTER TABLE staging.title_episode SET (autovacuum_enabled = false);
ALTER TABLE staging.title_principals SET (autovacuum_enabled = false);
ALTER TABLE staging._title_ratings SET (autovacuum_enabled = false);
ALTER TABLE staging.name_basics SET (autovacuum_enabled = false);

commit;
