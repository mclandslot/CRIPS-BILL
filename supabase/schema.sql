-- ============================================================================
--  CRIPS Student Billing System — Supabase schema
--  Run this once in your project: Supabase Studio ▸ SQL Editor ▸ New query.
--  Safe to re-run; every statement is idempotent.
-- ============================================================================

-- ---------------------------------------------------------------- students --
create table if not exists public.students (
  id          text primary key,              -- matches the id the app generates
  name        text not null,
  klass       text not null,
  category    text not null check (category in ('staff', 'non-staff')),
  address     text not null default '',
  created_at  timestamptz not null default now()
);

create index if not exists students_klass_idx    on public.students (klass);
create index if not exists students_category_idx on public.students (category);

-- ------------------------------------------------------------------- bills --
-- One bill is the fee schedule for a whole category in a given term, so
-- (category, year, term) is unique. `lines` is a snapshot: [{feeId,label,debit}]
-- kept as jsonb so later edits to the fee catalogue never rewrite issued bills.
create table if not exists public.bills (
  id          text primary key,
  category    text not null check (category in ('staff', 'non-staff')),
  year        text not null,
  term        text not null,
  lines       jsonb not null default '[]'::jsonb,
  created_at  timestamptz not null default now(),
  constraint bills_one_per_category_term unique (category, year, term)
);

create index if not exists bills_period_idx on public.bills (year, term);

-- -------------------------------------------------------------------- fees --
-- The default fee catalogue shown when a new bill is created.
create table if not exists public.fees (
  id          text primary key,
  label       text not null,
  staff       numeric(10, 2) not null default 0,
  non_staff   numeric(10, 2) not null default 0,
  sort_order  integer not null default 0
);

-- ---------------------------------------------------------------- settings --
-- Letterhead and similar; a single row holding the cfg object.
create table if not exists public.settings (
  id    integer primary key default 1 check (id = 1),
  data  jsonb not null default '{}'::jsonb
);

insert into public.settings (id, data) values (1, '{}'::jsonb)
  on conflict (id) do nothing;

-- ============================================================================
--  Row Level Security
--
--  These tables hold children's names and home addresses. RLS is ON and only
--  SIGNED-IN users may read or write.
--
--  NOTE: the app as shipped does NOT sign in — it connects with the anon key
--  alone, so these policies will block it. Run policies-anon.sql to open the
--  tables up, which is what the current app expects.
--
--  Coming back to this file to lock things down again means restoring the
--  sign-in step in index.html too; the two go together.
-- ============================================================================

alter table public.students enable row level security;
alter table public.bills    enable row level security;
alter table public.fees     enable row level security;
alter table public.settings enable row level security;

-- Remove EVERY existing policy on these tables first, whatever it is called.
-- Dropping only our own policy names would leave anything created elsewhere
-- in place — for example a default "enable read access for all users" — and
-- that would silently defeat the sign-in requirement below.
do $$
declare r record;
begin
  for r in
    select policyname, tablename
      from pg_policies
     where schemaname = 'public'
       and tablename in ('students', 'bills', 'fees', 'settings')
  loop
    execute format('drop policy %I on public.%I', r.policyname, r.tablename);
  end loop;
end $$;

create policy "students: signed-in full access" on public.students
  for all to authenticated using (true) with check (true);

create policy "bills: signed-in full access" on public.bills
  for all to authenticated using (true) with check (true);

create policy "fees: signed-in full access" on public.fees
  for all to authenticated using (true) with check (true);

create policy "settings: signed-in full access" on public.settings
  for all to authenticated using (true) with check (true);
