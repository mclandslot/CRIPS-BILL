# Student Billing System

A browser-based terminal billing application for **Cocoa Research Institute Primary School**
(P. O. Box 8, New Tafo – Akim), implemented as a single self-contained HTML file.

Open `index.html` in any modern browser. No server, no build step, no installation.

## Features

- **Dashboard** — headline counts (total students, Staff, Non-Staff, classes) and a per-class
  breakdown showing each class's roll split by category.
- **Register students** — full name, class, address, and Staff / Non-Staff category.
- **Create bills per category** — choose Staff or Non-Staff, the academic year and the term.
  One bill is the fee schedule for that whole category.
- **Every student in the category is covered** — a bill applies to all of them at once, and
  any student registered later is picked up automatically, with no re-entry.
- **Automatic amounts** — the schedule is filled from the category defaults and stays editable.
- **Filter bills** by class, Staff / Non-Staff category, and student.
- **Preview and print** a bill that reproduces the official school layout — logo, letterhead,
  reference number, pupil name, class, term, year and address. Print one student's copy, or
  every covered student at once — one page each.
- **Print by class** — the Print Preview tab filters by Academic year & term, then Class, then
  Student. A class prints in one run with both Staff and Non-Staff pupils included, each on the
  amounts for their own category.
- **Saved by category** — bills are stored and grouped under Staff and Non-Staff. The Bills tab
  lists each bill with every student it covers.
- **Supabase backend (optional)** — point the app at a Supabase project and every change is
  saved to Postgres automatically. See [`supabase/README.md`](supabase/README.md). Without it
  the app runs exactly as before.
- **No browser storage** — nothing is written to `localStorage`, cookies or any browser store.
  Data lives in the open tab only; **Settings ▸ Data** saves it to a `.json` file and opens it
  again next session. The app warns before you close a tab holding unsaved work.

## Fee categories

Default termly amounts, editable under **Settings**:

| Debit item | Staff (GH¢) | Non-Staff (GH¢) |
|---|---:|---:|
| Tuition Fee | 160.00 | 200.00 |
| Snack | 300.00 | 300.00 |
| Printing & Stationery | 30.00 | 30.00 |
| Electricity | 15.00 | 15.00 |
| Repairs & Maintenance | 50.00 | 50.00 |
| Sanitation | 30.00 | 30.00 |
| P. T. A. Dues | 30.00 | 30.00 |
| Computing | 50.00 | 50.00 |
| User Fee (Library/Text Books) | 40.00 | 40.00 |
| Art / Life Skills Materials | 50.00 | 50.00 |
| KG Work Book / Branded Books | 160.00 | 160.00 |
| **Amount due to be paid** | **915.00** | **955.00** |

## Files

| File | Purpose |
|---|---|
| `index.html` | The entire application — markup, styles and logic. |
| `billing-data-*.json` | Exported data file — a portable snapshot of all records. |
| `supabase/` | Database schema, RLS policies and setup guide for the optional cloud backend. |
| `school-logo.png` | Letterhead crest, loaded by the printed bill. |
| `staff-bill.jpg`, `non-staff-bill.jpg` | Scans of the original bills used as the layout reference. |

Keep `index.html` and `school-logo.png` in the same folder, or the crest will not appear on the printout.

## Tech stack

HTML, CSS and JavaScript — no frameworks or external dependencies.
