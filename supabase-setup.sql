-- Anna Expense Tracker — Supabase Setup (v3)
-- Safe: only touches anna_ prefixed tables
-- Run in: Database → SQL Editor → New query

drop table if exists anna_monthly_overrides cascade;
drop table if exists anna_expenses          cascade;
drop table if exists anna_loans             cascade;
drop table if exists anna_settings          cascade;

-- ── Settings per month ──
create table anna_settings (
  year   int     not null,
  month  int     not null,
  salary numeric not null default 0,
  primary key (year, month)
);

-- ── Expenses per month ──
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

-- ── Loans per month ──
create table anna_loans (
  id         serial  primary key,
  name       text    not null,
  monthly    numeric not null default 0,
  year       int     not null,
  month      int     not null,
  created_at timestamptz default now()
);
create index on anna_loans (year, month);

-- ── Row Level Security ──
alter table anna_settings enable row level security;
alter table anna_expenses  enable row level security;
alter table anna_loans     enable row level security;

create policy "anon_all" on anna_settings for all to anon using (true) with check (true);
create policy "anon_all" on anna_expenses  for all to anon using (true) with check (true);
create policy "anon_all" on anna_loans     for all to anon using (true) with check (true);
