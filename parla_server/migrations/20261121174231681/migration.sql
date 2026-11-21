BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ad_campaign" (
    "id" bigserial PRIMARY KEY,
    "advertiserId" bigint NOT NULL,
    "title" text NOT NULL,
    "startsOn" text NOT NULL,
    "endsOn" text NOT NULL,
    "priceNote" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "ad_campaign_advertiser_idx" ON "ad_campaign" USING btree ("advertiserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "advertiser" (
    "id" bigserial PRIMARY KEY,
    "company" text NOT NULL,
    "email" text,
    "contractNumber" text,
    "contractStart" text,
    "contractEnd" text,
    "note" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "advertiser_name_idx" ON "advertiser" USING btree ("company");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ad_campaign"
    ADD CONSTRAINT "ad_campaign_fk_0"
    FOREIGN KEY("advertiserId")
    REFERENCES "advertiser"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261121174231681', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261121174231681', "timestamp" = now();

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
