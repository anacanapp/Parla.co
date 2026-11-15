BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "sport_record" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "ciphertext" text NOT NULL,
    "nonce" text NOT NULL,
    "format" bigint NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "sport_record_user_idx" ON "sport_record" USING btree ("authUserId");


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261115145230093', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261115145230093', "timestamp" = now();

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
