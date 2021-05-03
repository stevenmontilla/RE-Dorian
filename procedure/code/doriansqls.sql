
#add a count field
AddGeometryColumn ('wilmer','dorian','geom',4269,'POINT',2, false)
UPDATE dorian set geom = st_transform(st_setsrid(st_makepoint(lng,lat),4326),4269)



'join by location'
ALTER TABLE dorian
ADD COLUMN cuenta int;

UPDATE dorian
SET cuenta = 1

CREATE TABLE counties_dorian
AS
SELECT dorian.*, counties.geoid as geoid
FROM dorian INNER JOIN counties
ON st_intersects(counties.geometry, dorian.geom);

CREATE TABLE dorian_grouped
AS
SELECT COUNT(cuenta) as tweet_ct, geoid
FROM counties_dorian
GROUP BY geoid

CREATE TABLE counties_w_dorian
AS
SELECT counties.*, dorian_grouped.tweet_ct
FROM counties LEFT JOIN dorian_grouped
ON counties.geoid = dorian_grouped.geoid;

UPDATE counties_w_dorian
SET tweet_ct = 0
WHERE tweet_ct IS NULL;

AddGeometryColumn ('wilmer','november','geom',4269,'POINT',2, false)
UPDATE november set geom = st_transform(st_setsrid(st_makepoint(lng,lat),4326),4269)

ALTER TABLE november
ADD COLUMN cuenta int;

UPDATE november
SET cuenta = 1

CREATE TABLE counties_nov
AS
SELECT november.*, counties.geoid as geoid
FROM november INNER JOIN counties
ON st_intersects(counties.geometry, november.geom);

CREATE TABLE nov_grouped
AS
SELECT COUNT(cuenta) as nov_tw_ct, geoid
FROM counties_nov
GROUP BY geoid

CREATE TABLE counties_w_nov_dor
AS
SELECT counties_w_dorian.*, nov_grouped.nov_tw_ct as nov_tw_ct
FROM counties_w_dorian LEFT JOIN nov_grouped
ON counties_w_dorian.geoid = nov_grouped.geoid;

UPDATE counties_w_nov_dor
SET nov_tw_ct = 0
WHERE nov_tw_ct IS NULL;
