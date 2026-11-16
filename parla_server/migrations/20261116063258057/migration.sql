BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "staff_invite" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "role" text NOT NULL,
    "codeHash" text NOT NULL,
    "invitedBy" uuid NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "usedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "staff_invite_email_idx" ON "staff_invite" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "staff_member" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "role" text NOT NULL,
    "active" boolean NOT NULL,
    "totpSecret" text,
    "totpNonce" text,
    "totpConfirmedAt" timestamp without time zone,
    "lastTotpStep" bigint,
    "failedTotp" bigint NOT NULL,
    "lockedUntil" timestamp without time zone,
    "invitedBy" uuid,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "staff_member_user_idx" ON "staff_member" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "staff_session" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "authId" text NOT NULL,
    "verifiedAt" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "staff_session_auth_idx" ON "staff_session" USING btree ("authId");


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261116063258057', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261116063258057', "timestamp" = now();

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
