-- Anna Expense Tracker — Supabase Setup (v2)
-- Safe to run on existing project: only touches anna_ prefixed tables
-- Run in: Database → SQL Editor → New query

-- Drop old anna_ tables cleanly
drop table if exists anna_monthly_overrides cascade;
drop table if exists anna_expenses          cascade;
drop table if exists anna_loans             cascade;
drop table if exists anna_settings          cascade;

-- ── Settings ──
create table anna_settings (
  id         int     primary key default 1,
  salary     numeric not null default 0,
  updated_at timestamptz default now()
);

-- ── Expenses (month-specific) ──
create table anna_expenses (
  id         serial  primary key,
  name       text    not null,
  category   text    not null default 'Other',
  amount     numeric not null default 0,
  note       text             default '',
  year       int     not null,
  month      int     not null,
  created_at timestamptz      default now()
);

create index on anna_expenses (year, month);

-- ── Loans (recurring every month) ──
create table anna_loans (
  id         text    primary key,
  name       text    not null,
  monthly    numeric not null default 0,
  created_at timestamptz default now()
);

-- ── Row Level Security ──
alter table anna_settings enable row level security;
alter table anna_expenses  enable row level security;
alter table anna_loans     enable row level security;

create policy "anon_all" on anna_settings for all to anon using (true) with check (true);
create policy "anon_all" on anna_expenses  for all to anon using (true) with check (true);
create policy "anon_all" on anna_loans     for all to anon using (true) with check (true);

-- ── Default salary row ──
insert into anna_settings (id, salary) values (1, 0);
