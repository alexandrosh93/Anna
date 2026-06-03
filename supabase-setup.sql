-- Anna Expense Tracker — Supabase Setup
-- Run this once in your Supabase SQL Editor (Database → SQL Editor → New query)

-- ── Tables ──

create table if not exists anna_settings (
  id   int primary key default 1,
  salary numeric not null default 3183.13,
  updated_at timestamptz default now()
);

create table if not exists anna_expenses (
  id        serial primary key,
  name      text    not null,
  category  text    not null default 'Other',
  amount    numeric not null default 0,
  note      text             default '',
  recurring boolean          default true,
  created_at timestamptz     default now()
);

create table if not exists anna_loans (
  id       text    primary key,
  name     text    not null,
  monthly  numeric not null default 0,
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

create policy "anon_all" on anna_settings          for all to anon using (true) with check (true);
create policy "anon_all" on anna_expenses          for all to anon using (true) with check (true);
create policy "anon_all" on anna_loans             for all to anon using (true) with check (true);
create policy "anon_all" on anna_monthly_overrides for all to anon using (true) with check (true);

-- ── Seed default data ──

insert into anna_settings (id, salary) values (1, 3183.13) on conflict (id) do nothing;

insert into anna_expenses (id, name, category, amount, note, recurring) values
  (1,  'Eurolife',            'Insurance',    120,  'Tax exempt',              true),
  (2,  'T-Roc Ασφάλεια',     'Insurance',     52,  'Car insurance',           true),
  (3,  'CNP FLAT',            'Insurance',     22,  'Home insurance ×10 mo',   true),
  (4,  'Σταθερά',             'Housing',      920,  'Fixed monthly',           true),
  (5,  'Primetel',            'Utilities',     77,  'Telecom',                 true),
  (6,  'EAC',                 'Utilities',     80,  'Electricity',             true),
  (7,  'WB',                  'Utilities',     20,  'Quarterly ÷3',            true),
  (8,  'ANNA',                'Health',        90,  'Health plan',             true),
  (9,  'Βιταμίνες',           'Health',        50,  '',                        true),
  (10, 'Φάρμακα',             'Health',       300,  '',                        true),
  (11, 'Φακοί',               'Health',       170,  'After health fund return',true),
  (12, 'Face Care',           'Personal Care', 40,  '',                        true),
  (13, 'Ialuna',              'Personal Care', 18,  '',                        true),
  (14, 'Σούπερ Μάρκετ',      'Groceries',    300,  '',                        true),
  (15, 'Πεζίνες',             'Leisure',       60,  'Pocket money',            true),
  (16, 'Κινόχρηστα',          'Leisure',       70,  '',                        true),
  (17, 'Card Installments',   'Installments', 150,  '',                        true),
  (18, 'Άδεια Κυκλοφορίας',  'Transport',     67,  'Annual ÷12',              true),
  (19, 'Fleksy',              'Transport',    262,  '',                        true)
on conflict (id) do nothing;

insert into anna_loans (id, name, monthly) values
  ('L1', 'Loan 1', 257.76),
  ('L2', 'Loan 2', 295.50),
  ('L3', 'Loan 3', 200.11),
  ('L4', 'Loan 4',  60.40)
on conflict (id) do nothing;

-- New expenses start from ID 100 (above the seeded range)
select setval('anna_expenses_id_seq', 100);
