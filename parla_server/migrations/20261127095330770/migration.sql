BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "site_salt" (
    "id" bigserial PRIMARY KEY,
    "day" text NOT NULL,
    "salt" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "site_salt_day_idx" ON "site_salt" USING btree ("day");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "site_stat_daily" (
    "id" bigserial PRIMARY KEY,
    "day" text NOT NULL,
    "metric" text NOT NULL,
    "target" text NOT NULL,
    "times" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "site_stat_daily_key_idx" ON "site_stat_daily" USING btree ("day", "metric", "target");
CREATE INDEX "site_stat_daily_day_idx" ON "site_stat_daily" USING btree ("day");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "site_visitor_mark" (
    "id" bigserial PRIMARY KEY,
    "day" text NOT NULL,
    "mark" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "site_visitor_mark_key_idx" ON "site_visitor_mark" USING btree ("day", "mark");


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261127095330770', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261127095330770', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20261015164015382', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261015164015382', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
