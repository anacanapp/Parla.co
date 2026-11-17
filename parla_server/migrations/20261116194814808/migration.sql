BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "media_asset" (
    "id" bigserial PRIMARY KEY,
    "key" text NOT NULL,
    "pixelWidth" bigint NOT NULL,
    "pixelHeight" bigint NOT NULL,
    "bytes" bigint NOT NULL,
    "license" text NOT NULL,
    "source" text,
    "altJson" text NOT NULL,
    "public" boolean NOT NULL,
    "createdBy" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "media_asset_key_idx" ON "media_asset" USING btree ("key");


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261116194814808', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261116194814808', "timestamp" = now();

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
