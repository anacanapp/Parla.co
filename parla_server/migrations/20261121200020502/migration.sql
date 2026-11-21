BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shop_order" (
    "id" bigserial PRIMARY KEY,
    "number" text NOT NULL,
    "authUserId" uuid NOT NULL,
    "productId" bigint NOT NULL,
    "productSlug" text NOT NULL,
    "productTitle" text NOT NULL,
    "brand" text NOT NULL,
    "seller" text NOT NULL,
    "quantity" bigint NOT NULL,
    "unitQepik" bigint NOT NULL,
    "totalQepik" bigint NOT NULL,
    "status" text NOT NULL,
    "transaction" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "paidAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "shop_order_number_idx" ON "shop_order" USING btree ("number");
CREATE INDEX "shop_order_user_idx" ON "shop_order" USING btree ("authUserId");


--
-- MIGRATION VERSION FOR parla
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('parla', '20261121200020502', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261121200020502', "timestamp" = now();

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
