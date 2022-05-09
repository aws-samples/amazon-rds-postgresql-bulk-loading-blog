/*
Create schemas
*/
create schema if not exists staging;

/*
IMDB staging tables

*/
create table staging.title (
	titleId text null,
	ordering int null,
	title text null,
	region text null,
	language text null,
	types text null,
	attributes text[] null,
	isOriginalTitle bit null
);

create table staging.title_basics (
	tconst text null,
	titleType text null,
	primaryTitle text null,
	originalTitle text null,
	isAdult bit null,
	startYear text null,
	endYear text null,
	runtimeMinutes text null,
	genres text null
);

create table staging.title_crew (
	tconst text null,
	directors text[] null,
	writers text[] null
);

create table staging.title_episode(
	tconst text null,
	parentTconst text null,
	seasonNumber text null,
	episodeNumber text null
);

create table staging.title_principals(
	tconst text null,
	ordering text null,
	nconst text null,
	category text null,
	job text null,
	characters text null
);

create table staging.title_ratings (
	tconst text null,
	averageRating text null,
	numVotes text null
);

create table staging.name_basics (
	nconst text null,
	primaryName text null,
	birthYear text null,
	deathYear text null,
	primaryProfession text null,
	knownForTitles text[] null
);
