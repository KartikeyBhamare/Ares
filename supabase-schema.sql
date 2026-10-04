-- Ares Supabase schema
create table if not exists public.workout_sets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  workout_date date not null,
  exercise text not null,
  set_number integer not null,
  completed boolean not null default false,
  updated_at timestamptz not null default now(),
  unique(user_id, workout_date, exercise, set_number)
);
alter table public.workout_sets enable row level security;
create policy "Users can read their own workout sets" on public.workout_sets for select using (auth.uid() = user_id);
create policy "Users can insert their own workout sets" on public.workout_sets for insert with check (auth.uid() = user_id);
create policy "Users can update their own workout sets" on public.workout_sets for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users can delete their own workout sets" on public.workout_sets for delete using (auth.uid() = user_id);
create index if not exists workout_sets_user_date_idx on public.workout_sets(user_id, workout_date desc);