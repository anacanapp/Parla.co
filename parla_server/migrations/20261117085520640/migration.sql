BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "support_message" (
    "id" bigserial PRIMARY KEY,
    "threadId" bigint NOT NULL,
    "fromStaff" boolean NOT NULL,
    "staffId" uuid,
    "ciphertext" text NOT NULL,
    "nonce" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "support_message_thread_idx" ON "support_message" USING btree ("threadId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "support_thread" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "open" boolean NOT NULL,
    "unreadByStaff" boolean NOT NULL,
    "unreadByUser" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "lastMessageAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "support_thread_user_idx" ON "support_thread" USING btree ("authUserId");


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261117085520640', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261117085520640', "timestamp" = now();

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
