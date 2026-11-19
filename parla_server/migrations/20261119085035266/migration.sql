BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "daily_active_count" ADD COLUMN "weekly" bigint;
ALTER TABLE "daily_active_count" ADD COLUMN "monthly" bigint;
ALTER TABLE "daily_active_count" ADD COLUMN "ios" bigint;
ALTER TABLE "daily_active_count" ADD COLUMN "android" bigint;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "daily_active_mark" ADD COLUMN "platform" text;
-- Older marks hashed the day with the account, the new ones only the
-- account: they cannot be compared, so the old ones are dropped.
DELETE FROM "daily_active_mark";
--
-- ACTION CREATE TABLE
--
CREATE TABLE "usage_daily" (
    "id" bigserial PRIMARY KEY,
    "day" text NOT NULL,
    "country" text NOT NULL,
    "platform" text NOT NULL,
    "event" text NOT NULL,
    "target" text NOT NULL,
    "times" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "usage_daily_key_idx" ON "usage_daily" USING btree ("day", "country", "platform", "event", "target");
CREATE INDEX "usage_daily_day_idx" ON "usage_daily" USING btree ("day");


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261119085035266', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261119085035266', "timestamp" = now();

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
