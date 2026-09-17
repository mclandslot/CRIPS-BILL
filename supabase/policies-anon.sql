-- ============================================================================
--  ⚠  TESTING / TRUSTED-MACHINE ONLY — NOT FOR SHARED OR PUBLISHED COPIES
--
--  This gives full read AND write access to anyone holding the project URL and
--  the anon key. That key ships inside index.html, so in practice it means
--  anyone who can open the page can read, change and delete every record.
--
--  These tables hold children's full names and home addresses. This is
--  appropriate only when index.html lives on a single office machine that is
--  not shared or hosted. To require a login again, run schema.sql.
--
--  Run this AFTER schema.sql (which creates the tables).
-- ============================================================================

-- Make sure RLS is on, whatever the tables were created by.
alter table public.students enable row level security;
alter table public.bills    enable row level security;
alter table public.fees     enable row level security;
alter table public.settings enable row level security;

-- Remove EVERY existing policy on these tables, whatever it is called.
-- Without this, a policy created elsewhere (for example a default "enable read
-- access for all users" added by the table editor) would survive and combine
-- with the ones below, leaving the real permissions unclear.
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

create policy "students: open (no sign-in)" on public.students
  for all to anon, authenticated using (true) with check (true);

create policy "bills: open (no sign-in)" on public.bills
  for all to anon, authenticated using (true) with check (true);

create policy "fees: open (no sign-in)" on public.fees
  for all to anon, authenticated using (true) with check (true);

create policy "settings: open (no sign-in)" on public.settings
  for all to anon, authenticated using (true) with check (true);

-- The settings row the app upserts into.
insert into public.settings (id, data) values (1, '{}'::jsonb)
  on conflict (id) do nothing;

-- ---------------------------------------------------------------------------
-- Check the result: you should see exactly four policies, all cmd = ALL,
-- all with {anon,authenticated}.
select tablename, policyname, roles, cmd
  from pg_policies
 where schemaname = 'public'
   and tablename in ('students', 'bills', 'fees', 'settings')
 order by tablename;
