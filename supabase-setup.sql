-- Anna Expense Tracker — Supabase Setup
-- Run this in SQL Editor (Database → SQL Editor → New query)
-- Safe on existing projects: all new tables are prefixed anna_

-- ── Create tables ──

create table if not exists anna_settings (
  id         int     primary key default 1,
  salary     numeric not null default 0,
  updated_at timestamptz default now()
);

create table if not exists anna_expenses (
  id         serial  primary key,
  name       text    not null,
  category   text    not null default 'Other',
  amount     numeric not null default 0,
  note       text             default '',
  recurring  boolean          default true,
  created_at timestamptz      default now()
);

create table if not exists anna_loans (
  id         text    primary key,
  name       text    not null,
  monthly    numeric not null default 0,
  created_at timestamptz default now()
);

create table if not exists anna_monthly_overrides (
  id         serial  primary key,
  expense_id int     references anna_expenses(id) on delete cascade,
  year       int     not null,
  month      int     not null,
  amount     numeric not null,
  unique(expense_id, year, month)
);

-- ── Row Level Security ──

alter table anna_settings          enable row level security;
alter table anna_expenses          enable row level security;
alter table anna_loans             enable row level security;
alter table anna_monthly_overrides enable row level security;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='anna_settings'          and policyname='anon_all') then
    create policy "anon_all" on anna_settings          for all to anon using (true) with check (true); end if;
  if not exists (select 1 from pg_policies where tablename='anna_expenses'          and policyname='anon_all') then
    create policy "anon_all" on anna_expenses          for all to anon using (true) with check (true); end if;
  if not exists (select 1 from pg_policies where tablename='anna_loans'             and policyname='anon_all') then
    create policy "anon_all" on anna_loans             for all to anon using (true) with check (true); end if;
  if not exists (select 1 from pg_policies where tablename='anna_monthly_overrides' and policyname='anon_all') then
    create policy "anon_all" on anna_monthly_overrides for all to anon using (true) with check (true); end if;
end $$;

-- ── Clear any previously seeded data ──
truncate anna_monthly_overrides restart identity cascade;
truncate anna_expenses          restart identity cascade;
truncate anna_loans;
delete from anna_settings;

-- ── Default salary row (edit in the app) ──
insert into anna_settings (id, salary) values (1, 0);
