# Products and ingredient statuses (M5, M6)

## What the app shows

- **Product search (M-20, M-22)** by name or brand. The app asks our server;
  the server asks Parla's own catalogue and Open Beauty Facts. The app never
  calls Open Beauty Facts itself, so users' IP addresses do not reach a third
  party. Searches are not stored, logged or linked to the user (the server
  keeps a 10-minute cache keyed by the query text only).
- **Product detail (M-21)** with the ingredient list as printed, each
  ingredient's **EU status**, and an ingredient sheet (M-23) with the annex
  entry, the official conditions in their original English wording, and the
  export date.
- No personal compatibility yet (no quiz or health data is used). That part
  needs the dermatologist and lawyer review first (MDR boundary).

## Wording rules

- Neutral statuses with a source and date only: "EU: allowed with
  restrictions (Annex III, entry 98)". Never "harmful", "toxic" or similar;
  `products_test.dart` fails if such a word appears in any language.
- No red or warning colours for statuses.
- Every product page says: the statuses come from the EU regulation, are not
  an Azerbaijani rule, are not a safety assessment, and names are matched
  automatically. Products from Open Beauty Facts also say the list may
  contain mistakes and carry the ODbL notice.
- "No separate entry in the EU annexes" means only that: most ingredients
  are not in Annexes II to VI.

## Where the statuses come from

Regulation (EC) No 1223/2009, Annexes II (prohibited), III (restricted),
IV (colorants), V (preservatives) and VI (UV filters), as published in the
European Commission's **CosIng** database. Nothing is typed by hand.

### Importing a new export

1. In CosIng (ec.europa.eu/growth/tools-databases/cosing), open each annex
   (II to VI) and export it as CSV.
2. From `parla_shared`:
   ```bash
   dart run tool/import_cosing.dart --date YYYY-MM-DD \
     annex_ii.csv:II annex_iii.csv:III annex_iv.csv:IV annex_v.csv:V annex_vi.csv:VI
   ```
   The tool rewrites `lib/src/cosing_data.dart` and formats it. If the
   export's columns change, it stops and prints the headers it found
   instead of importing nothing.
3. Open a pull request with the CSV files' download date. Review a few
   entries against CosIng before merging.

Until the first import, `cosing_data.dart` is empty and the app shows
ingredient lists without statuses, with a note saying so.

## Product data

- **Open Beauty Facts**: open community database, licence **ODbL**. We show
  the source and licence on every product from it. If we ever store or
  change their data, the changes must be shared under the same licence
  (lawyer to confirm).
- **Parla catalogue** (`parla_server/lib/src/products/catalog.dart`): for
  products Open Beauty Facts lacks, mainly Azerbaijani brands. Each product
  is added in a pull request, with the ingredient list copied exactly from
  the package and a note where it came from.

## Open legal questions

1. Which reference is right for Azerbaijan? Until the lawyer answers, the
   app shows EU statuses and says they are not an Azerbaijani rule.
   Kazakhstan applies the EAEU technical regulation TR CU 009/2011; Türkiye's
   cosmetics regulation follows the EU annexes.
2. ODbL obligations for showing Open Beauty Facts data in the app.
3. Whether showing "EU: on the list of prohibited substances" for an
   automatic name match needs extra wording.
