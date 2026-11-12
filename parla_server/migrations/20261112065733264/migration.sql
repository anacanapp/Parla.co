BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "deleted_account" (
    "id" bigserial PRIMARY KEY,
    "pseudonym" uuid NOT NULL,
    "deletedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "deleted_account_pseudonym_idx" ON "deleted_account" USING btree ("pseudonym");


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261112065733264', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261112065733264', "timestamp" = now();

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
