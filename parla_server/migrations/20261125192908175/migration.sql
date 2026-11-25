BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "push_job" (
    "id" bigserial PRIMARY KEY,
    "contentId" bigint NOT NULL,
    "status" text NOT NULL,
    "sent" bigint NOT NULL,
    "cursor" uuid,
    "leaseUntil" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "finishedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "push_job_content_idx" ON "push_job" USING btree ("contentId");


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261125192908175', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261125192908175', "timestamp" = now();

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
