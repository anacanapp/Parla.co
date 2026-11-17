import 'package:serverpod/serverpod.dart';

/// Database-level append-only rules for `consent_record` and `audit_log`
/// (checklist AUD-2). Triggers refuse every UPDATE and DELETE except:
///
/// - `audit_log`: changing only `actorId`/`objectId` (a deleted account's
///   id replaced by its pseudonym) and deleting rows older than 365 days.
/// - `consent_record`: changing only `authUserId` (pseudonym) and deleting
///   rows of accounts deleted more than 3 years ago.
///
/// Installed at start-up (idempotent), so every database, tests included,
/// has them. Times are stored in UTC without a time zone.
const appendOnlySql = r'''
CREATE OR REPLACE FUNCTION parla_audit_log_guard() RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    IF OLD."createdAt" < (now() AT TIME ZONE 'utc') - interval '365 days' THEN
      RETURN OLD;
    END IF;
    RAISE EXCEPTION 'audit_log is append-only';
  END IF;
  IF NEW.id = OLD.id
     AND NEW."actorRole" = OLD."actorRole"
     AND NEW.action = OLD.action
     AND NEW."objectType" = OLD."objectType"
     AND NEW."createdAt" = OLD."createdAt" THEN
    RETURN NEW;
  END IF;
  RAISE EXCEPTION 'audit_log is append-only';
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS parla_audit_log_guard ON audit_log;
CREATE TRIGGER parla_audit_log_guard BEFORE UPDATE OR DELETE ON audit_log
  FOR EACH ROW EXECUTE FUNCTION parla_audit_log_guard();

CREATE OR REPLACE FUNCTION parla_consent_record_guard() RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    IF EXISTS (
      SELECT 1 FROM deleted_account d
      WHERE d.pseudonym = OLD."authUserId"
        AND d."deletedAt" < (now() AT TIME ZONE 'utc') - interval '3 years'
    ) THEN
      RETURN OLD;
    END IF;
    RAISE EXCEPTION 'consent_record is append-only';
  END IF;
  IF NEW.id = OLD.id
     AND NEW."consentType" = OLD."consentType"
     AND NEW.granted = OLD.granted
     AND NEW."textVersion" = OLD."textVersion"
     AND NEW."textHash" = OLD."textHash"
     AND NEW.language = OLD.language
     AND NEW.source = OLD.source
     AND NEW."createdAt" = OLD."createdAt" THEN
    RETURN NEW;
  END IF;
  RAISE EXCEPTION 'consent_record is append-only';
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS parla_consent_record_guard ON consent_record;
CREATE TRIGGER parla_consent_record_guard BEFORE UPDATE OR DELETE
  ON consent_record
  FOR EACH ROW EXECUTE FUNCTION parla_consent_record_guard();
''';

/// Installs or refreshes the guards.
Future<void> installAppendOnlyGuards(Session session) async {
  await session.db.unsafeExecute(appendOnlySql);
}
