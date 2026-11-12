BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "health_key" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "wrappedKey" text NOT NULL,
    "nonce" text NOT NULL,
    "kekVersion" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "health_key_user_idx" ON "health_key" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "health_record" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "ciphertext" text NOT NULL,
    "nonce" text NOT NULL,
    "contentVersion" text NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "health_record_user_idx" ON "health_record" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "quiz_answer" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "questionId" text NOT NULL,
    "optionIds" json NOT NULL,
    "contentVersion" text NOT NULL,
    "answeredAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "quiz_answer_user_question_idx" ON "quiz_answer" USING btree ("authUserId", "questionId");


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261112064252864', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261112064252864', "timestamp" = now();

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
