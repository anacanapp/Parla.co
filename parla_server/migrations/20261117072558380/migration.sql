BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "daily_active_count" (
    "id" bigserial PRIMARY KEY,
    "day" text NOT NULL,
    "accounts" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "daily_active_count_day_idx" ON "daily_active_count" USING btree ("day");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "daily_active_mark" (
    "id" bigserial PRIMARY KEY,
    "day" text NOT NULL,
    "mark" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "daily_active_mark_idx" ON "daily_active_mark" USING btree ("day", "mark");


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261117072558380', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261117072558380', "timestamp" = now();

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
