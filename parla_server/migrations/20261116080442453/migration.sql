BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "content_item" (
    "id" bigserial PRIMARY KEY,
    "kind" text NOT NULL,
    "slug" text NOT NULL,
    "category" text NOT NULL,
    "status" text NOT NULL,
    "draftJson" text NOT NULL,
    "publishedJson" text,
    "reviewedBy" uuid,
    "reviewedAt" timestamp without time zone,
    "reviewNote" text,
    "publishedReviewedAt" timestamp without time zone,
    "consentRecordedAt" timestamp without time zone,
    "consentNote" text,
    "createdBy" uuid NOT NULL,
    "updatedBy" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "publishedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "content_item_slug_idx" ON "content_item" USING btree ("kind", "slug");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "nutrition_record" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "ciphertext" text NOT NULL,
    "nonce" text NOT NULL,
    "format" bigint NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "nutrition_record_user_idx" ON "nutrition_record" USING btree ("authUserId");


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261116080442453', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261116080442453', "timestamp" = now();

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
