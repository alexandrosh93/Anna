-- Run this ONCE in Supabase → SQL Editor
-- Adds the anna_planned table to an existing Anna installation

create table if not exists anna_planned (
  id         serial  primary key,
  name       text    not null,
  category   text    not null default 'Other',
  amount     numeric not null default 0,
  note       text             default '',
  year       int     not null,
  month      int     not null,
  created_at timestamptz      default now()
);

create index if not exists anna_planned_year_month on anna_planned (year, month);

alter table anna_planned enable row level security;

create policy "anon_all" on anna_planned for all to anon using (true) with check (true);
