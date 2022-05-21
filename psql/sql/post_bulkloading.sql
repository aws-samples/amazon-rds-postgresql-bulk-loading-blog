begin

CHECKPOINT;
VACUUM staging.title;
VACUUM staging.title_crew;
VACUUM staging.title_basics;
VACUUM staging.title_episode;
VACUUM staging.title_principals;
VACUUM staging.title_ratings;

ALTER TABLE staging.title SET (autovacuum_enabled = true);
ALTER TABLE staging.title_crew SET (autovacuum_enabled = true);
ALTER TABLE staging.title_basics SET (autovacuum_enabled = true);
ALTER TABLE staging.title_episode SET (autovacuum_enabled = true);
ALTER TABLE staging.title_principals SET (autovacuum_enabled = true);
ALTER TABLE staging.title_ratings SET (autovacuum_enabled = true);

end;
