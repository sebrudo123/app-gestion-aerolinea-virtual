-- Vertex Airlines - Supabase Schema
-- Ejecutar en Supabase: SQL Editor (copy paste)

-- =============================================
-- 1. Tabla de perfiles de piloto (vinculada a Auth)
-- =============================================
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text not null,
  email text not null unique,
  callsign text,
  rank text default 'CADETE',
  platform text default 'Xbox',
  level int default 12,
  xp int default 2480,
  xp_next int default 5000,
  flight_hours text default '248h 32m',
  license text default 'Comercial (ATPL)',
  airline_name text default 'SkyLink Virtual',
  created_at timestamptz default now()
);

-- =============================================
-- 2. Tabla de vuelos
-- =============================================
create table if not exists public.flights (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles (id) on delete cascade,
  callsign text not null,
  origin text not null,
  destination text not null,
  aircraft text,
  status text default 'programado',  -- programado | en_vuelo | aprobado
  altitude_ft int,
  speed_kts int,
  distance_nm int,
  eta text,
  created_at timestamptz default now()
);

-- =============================================
-- 3. Tabla de tickets de soporte
-- =============================================
create table if not exists public.tickets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles (id) on delete cascade,
  ticket_no text unique not null,
  title text not null,
  status text default 'Abierto',   -- Abierto | En proceso | Resuelto | Cerrado
  created_at timestamptz default now()
);

-- =============================================
-- 4. Tabla de aerolíneas
-- =============================================
create table if not exists public.airlines (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid references public.profiles (id) on delete set null,
  name text not null unique,
  members int default 1,
  aircraft int default 0,
  flights int default 0,
  income text default '$0',
  level int default 1,
  xp int default 0,
  xp_next int default 20000,
  created_at timestamptz default now()
);

-- =============================================
-- 5. Tabla de flota
-- =============================================
create table if not exists public.fleet (
  id uuid primary key default gen_random_uuid(),
  airline_id uuid references public.airlines (id) on delete cascade,
  aircraft_type text not null,
  registration text,
  seats int,
  status text default 'EN SERVICIO',
  created_at timestamptz default now()
);

-- =============================================
-- 6. RLS (Row Level Security) - cada usuario solo su data
-- =============================================
alter table public.profiles enable row level security;
alter table public.flights enable row level security;
alter table public.tickets enable row level security;
alter table public.airlines enable row level security;
alter table public.fleet enable row level security;

create policy "own profile" on public.profiles for select using (auth.uid() = id);
create policy "own profile update" on public.profiles for update using (auth.uid() = id);
create policy "own flights" on public.flights for all using (auth.uid() = user_id);
create policy "own tickets" on public.tickets for all using (auth.uid() = user_id);
create policy "own airline" on public.airlines for all using (auth.uid() = owner_id);
create policy "own fleet" on public.fleet for all using (
  auth.uid() in (select owner_id from public.airlines where id = airline_id)
);

-- =============================================
-- 7. Trigger: crear perfil automático al registrarse
-- =============================================
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, username, email, platform, rank)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'username', split_part(new.email, '@', 1)),
    new.email,
    coalesce(new.raw_user_meta_data ->> 'platform', 'Xbox'),
    'CADETE'
  );
  return new;
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- =============================================
-- 8. Datos iniciales (opcional)
-- =============================================
insert into public.airlines (name, members, aircraft, flights, income, level)
values ('SkyLink Virtual', 12, 6, 248, '$2,480,650', 3)
on conflict (name) do nothing;

insert into public.airlines (name)
values ('Global Air'), ('Blue Horizon'), ('SkyTeam VA')
on conflict (name) do nothing;