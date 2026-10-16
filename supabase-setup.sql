-- FAZAG School Management: run this ONCE in Supabase > SQL Editor > New query > Run.

-- 1. Data table (every record is one row: a key and a JSON value)
create table if not exists public.school_data (
  k text primary key,
  v jsonb,
  updated_at timestamptz default now()
);
alter table public.school_data enable row level security;

drop policy if exists "school read"   on public.school_data;
drop policy if exists "school insert" on public.school_data;
drop policy if exists "school update" on public.school_data;
drop policy if exists "school delete" on public.school_data;
create policy "school read"   on public.school_data for select to authenticated using (true);
create policy "school insert" on public.school_data for insert to authenticated with check (true);
create policy "school update" on public.school_data for update to authenticated using (true) with check (true);
create policy "school delete" on public.school_data for delete to authenticated using (true);

-- 2. E-Library storage bucket (PDF only, 30 MB max per file, readable by link)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('books', 'books', true, 31457280, array['application/pdf'])
on conflict (id) do update set file_size_limit = 31457280, allowed_mime_types = array['application/pdf'];

drop policy if exists "books upload" on storage.objects;
drop policy if exists "books update" on storage.objects;
drop policy if exists "books delete" on storage.objects;
create policy "books upload" on storage.objects for insert to authenticated with check (bucket_id = 'books');
create policy "books update" on storage.objects for update to authenticated using (bucket_id = 'books');
create policy "books delete" on storage.objects for delete to authenticated using (bucket_id = 'books');
