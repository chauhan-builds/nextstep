-- NextStep database schema for Supabase.
-- How to run: Supabase dashboard -> SQL Editor -> New query -> paste this whole file -> Run.
-- Safe to run more than once.

-- 1. Tables ---------------------------------------------------------------

create table if not exists public.profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  name       text not null default '',
  track      text not null default 'c10',
  exam       date,
  notes      text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.progress (
  user_id   uuid not null references auth.users(id) on delete cascade,
  topic_key text not null,
  primary key (user_id, topic_key)
);

create table if not exists public.study_log (
  user_id uuid not null references auth.users(id) on delete cascade,
  day     date not null,
  minutes int  not null default 0 check (minutes >= 0),
  primary key (user_id, day)
);

create table if not exists public.tasks (
  id         bigint generated always as identity primary key,
  user_id    uuid not null references auth.users(id) on delete cascade,
  text       text not null check (char_length(text) between 1 and 120),
  done       boolean not null default false,
  created_at timestamptz not null default now()
);

-- 2. Row level security: every student can only see and change their own rows

alter table public.profiles   enable row level security;
alter table public.progress   enable row level security;
alter table public.study_log  enable row level security;
alter table public.tasks      enable row level security;

drop policy if exists "own profile"  on public.profiles;
drop policy if exists "own progress" on public.progress;
drop policy if exists "own log"      on public.study_log;
drop policy if exists "own tasks"    on public.tasks;

create policy "own profile"  on public.profiles  for all to authenticated
  using (auth.uid() = id)      with check (auth.uid() = id);
create policy "own progress" on public.progress  for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own log"      on public.study_log for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own tasks"    on public.tasks     for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 3. Create a profile row automatically when a student signs up

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, name, track)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', ''),
    coalesce(new.raw_user_meta_data->>'track', 'c10')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
