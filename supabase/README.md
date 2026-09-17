# Supabase setup

Saves students, bills, the fee catalogue and the letterhead to a Supabase
(Postgres) project, so records survive closing the tab and are shared across
every computer that opens the app.

Without the `config.js` step below, the app runs exactly as it does today —
in memory, with **Save data file / Open data file** — so nothing breaks if you
stop half way.

## 1. Create the project

1. Sign in at [supabase.com](https://supabase.com) and create a new project.
2. Pick a region close to the school; the free tier is enough for a primary roll.
3. Wait for provisioning to finish (a minute or two).

## 2. Create the tables

1. Open **SQL Editor ▸ New query**.
2. Paste the whole of [`schema.sql`](schema.sql) and press **Run**.
3. Check **Table Editor** — you should see `students`, `bills`, `fees` and `settings`.

`schema.sql` is safe to run again later; every statement is idempotent.

## 3. Open the tables to the app

`schema.sql` leaves the tables locked to signed-in users only. **The app does not
sign in** — it connects with the anon key alone — so one more step is required:

1. Open **SQL Editor ▸ New query**.
2. Paste the whole of [`policies-anon.sql`](policies-anon.sql) and press **Run**.
3. The query prints the resulting policies: four rows, all `cmd = ALL`, all
   `{anon,authenticated}`.

Both files clear every existing policy on these four tables before creating their
own, so the end state is the same no matter what was there beforehand.

> ⚠ This means anyone who can open `index.html` can read and change every record,
> because the anon key travels with the page. Keep the file on a single office
> machine; do not host or share it. Running `schema.sql` again restores the
> locked-down policies, but the app would then need its sign-in step back.

## 4. Point the app at the project

1. Copy `config.example.js` to `config.js` in this folder.
2. Fill in `url` and `anonKey` from **Project Settings ▸ API**.

```js
window.SUPABASE_CONFIG = {
  url:     "https://abcdefghijkl.supabase.co",
  anonKey: "eyJhbGciOi..."
};
```

Use the **anon / public** key. Never the `service_role` key — that one bypasses
RLS and would give anyone who opened the page unrestricted access.

## 5. Use it

Open `index.html`. There is no cloud panel and nothing to switch on — if `config.js` is
present the app connects on its own. From then on:

- Every change is pushed to Supabase automatically, about a second after you stop typing.
- Existing records are pulled down each time the page loads.
- To refresh from the database mid-session, reload the page.

## How the data maps

| App | Table | Notes |
|---|---|---|
| Students | `students` | `klass` is the class name; `category` is `staff` / `non-staff` |
| Bills | `bills` | One row per category + year + term, enforced by a unique constraint |
| Bill lines | `bills.lines` | `jsonb` array of `{feeId, label, debit}`, snapshotted at save time |
| Fee catalogue | `fees` | Defaults for new bills; `sort_order` preserves the printed order |
| Letterhead | `settings` | A single row (`id = 1`) holding the settings object |

Bill lines are stored as `jsonb` rather than their own table on purpose: an
issued bill must keep the labels and amounts it was printed with, even if the
fee catalogue is edited afterwards.

## Notes and limits

- **Sessions are not persisted.** The app sets `persistSession: false`, so
  supabase-js writes nothing to `localStorage`. Sign-in lasts until the tab is
  closed — a deliberate consequence of keeping the app free of browser storage.
- **Last write wins.** Two people editing the same record at once will have one
  overwrite the other; there is no merge or locking.
- **`config.js` is yours, not the repo's.** If you put this project in git, add
  `supabase/config.js` to `.gitignore`.
- **Keep taking data files.** *Save data file* still works and is worth doing
  before big changes — Supabase's own backups are limited on the free tier.
