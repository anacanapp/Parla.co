BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "staff_session" CASCADE;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "staff_member" DROP COLUMN "totpSecret";
ALTER TABLE "staff_member" DROP COLUMN "totpNonce";
ALTER TABLE "staff_member" DROP COLUMN "totpConfirmedAt";
ALTER TABLE "staff_member" DROP COLUMN "lastTotpStep";
ALTER TABLE "staff_member" DROP COLUMN "failedTotp";
ALTER TABLE "staff_member" DROP COLUMN "lockedUntil";

--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261118183512232', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261118183512232', "timestamp" = now();

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
