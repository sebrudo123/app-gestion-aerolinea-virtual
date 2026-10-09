'use client'

import { useState } from 'react'
import {
  ArrowDownRight,
  ArrowUpRight,
  Bell,
  CalendarDays,
  ChevronRight,
  CircleHelp,
  CloudSun,
  Gauge,
  LayoutDashboard,
  Map,
  Plane,
  Radio,
  Settings,
  ShieldCheck,
  Trophy,
  UserRound,
  Users,
  WalletCards,
  Wind,
} from 'lucide-react'

const quickLinks = [
  { label: 'Plan de vuelo', icon: Map, tone: 'amber' },
  { label: 'Mis planes', icon: CalendarDays, tone: 'blue' },
  { label: 'Rankings', icon: Trophy, tone: 'purple' },
  { label: 'Mi flota', icon: Plane, tone: 'green' },
]

const flights = [
  { route: 'LEMD → LEBL', number: 'VDA 204', aircraft: 'A320neo', status: 'Completado', time: '01:42', color: 'green' },
  { route: 'LEBL → GCFV', number: 'VDA 318', aircraft: 'B737-800', status: 'Pendiente', time: '—', color: 'amber' },
  { route: 'GCFV → GCTS', number: 'VDA 451', aircraft: 'A321LR', status: 'Rechazado', time: '02:06', color: 'red' },
]

export default function Page() {
  const [active, setActive] = useState('Inicio')
  const [icao, setIcao] = useState('LEMD')
  const [searched, setSearched] = useState(false)

  return (
    <main className="min-h-screen bg-[#07101f] text-slate-100">
      <div className="mx-auto flex min-h-screen max-w-[1500px]">
        <aside className="hidden w-[250px] shrink-0 border-r border-white/[0.07] bg-[#091526] px-5 py-7 lg:flex lg:flex-col">
          <div className="flex items-center gap-3 px-2">
            <div className="grid size-10 place-items-center rounded-xl bg-amber-400 text-[#07101f] shadow-[0_0_24px_rgba(245,181,56,.2)]"><Plane className="size-5" /></div>
            <div><p className="text-sm font-bold tracking-wide text-white">AEROVIA</p><p className="text-[10px] uppercase tracking-[.22em] text-slate-500">Virtual Airlines</p></div>
          </div>
          <nav className="mt-12 flex flex-col gap-2" aria-label="Navegación principal">
            <p className="mb-2 px-3 text-[10px] font-semibold uppercase tracking-[.2em] text-slate-600">Centro de operaciones</p>
            {[
              ['Inicio', LayoutDashboard], ['Vuelos', Plane], ['Live tracker', Radio], ['Rankings', Trophy], ['Mi flota', Wind],
            ].map(([label, Icon]) => <button key={label as string} onClick={() => setActive(label as string)} className={`flex items-center gap-3 rounded-xl px-3 py-3 text-sm transition ${active === label ? 'bg-amber-400 font-semibold text-[#07101f]' : 'text-slate-400 hover:bg-white/[.04] hover:text-white'}`}><Icon className="size-[18px]" />{label as string}{label === 'Live tracker' && <span className="ml-auto size-2 rounded-full bg-emerald-400" />}</button>)}
          </nav>
          <div className="mt-auto flex flex-col gap-2 border-t border-white/[.07] pt-5">
            <button className="flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-400 hover:bg-white/[.04] hover:text-white"><Settings className="size-[18px]" /> Ajustes</button>
            <button className="flex items-center gap-3 rounded-xl px-3 py-3 text-sm text-slate-400 hover:bg-white/[.04] hover:text-white"><CircleHelp className="size-[18px]" /> Centro de ayuda</button>
          </div>
        </aside>

        <section className="min-w-0 flex-1 px-5 pb-28 sm:px-8 lg:px-10 lg:pb-10">
          <header className="flex items-center justify-between py-6">
            <div><p className="text-xs font-medium text-slate-500">Miércoles, 09 de octubre de 2026</p><h1 className="mt-1 text-2xl font-semibold tracking-tight text-white">Buenos días, Alex</h1></div>
            <div className="flex items-center gap-3"><button aria-label="Notificaciones" className="relative rounded-xl border border-white/[.08] p-2.5 text-slate-400 hover:text-white"><Bell className="size-[18px]" /><span className="absolute right-2 top-2 size-1.5 rounded-full bg-amber-400" /></button><div className="flex items-center gap-3 rounded-full border border-white/[.08] bg-white/[.03] py-1.5 pl-1.5 pr-3"><div className="grid size-8 place-items-center rounded-full bg-gradient-to-br from-amber-300 to-orange-600 text-xs font-bold text-[#07101f]">AR</div><div className="hidden text-left sm:block"><p className="text-xs font-semibold text-white">Alex Rivera</p><p className="text-[10px] text-amber-400">Primer Oficial</p></div></div></div>
          </header>

          <div className="mb-6 flex items-center gap-2 rounded-xl border border-amber-300/15 bg-amber-300/[.06] px-4 py-3 text-sm"><ShieldCheck className="size-4 text-amber-300" /><span className="text-slate-300">Sistema operativo estable. Tienes <b className="text-amber-300">2 PIREPs</b> pendientes de revisión.</span><button className="ml-auto hidden text-xs font-semibold text-amber-300 sm:block">Revisar <ChevronRight className="ml-1 inline size-3" /></button></div>

          <div className="grid gap-5 xl:grid-cols-[1.5fr_1fr]">
            <section className="relative overflow-hidden rounded-2xl border border-white/[.09] bg-gradient-to-br from-[#112b48] via-[#10233b] to-[#0d1728] p-6 sm:p-7"><div className="absolute -right-16 -top-20 size-64 rounded-full bg-amber-400/[.07] blur-3xl" /><div className="relative flex items-start justify-between"><div><p className="text-xs font-medium uppercase tracking-[.18em] text-amber-300">Perfil del piloto</p><h2 className="mt-3 text-2xl font-semibold text-white">Alex Rivera <span className="ml-2 align-middle rounded-md bg-amber-400/15 px-2 py-1 text-[10px] font-semibold uppercase tracking-wider text-amber-300">VDA-042</span></h2><p className="mt-1 text-sm text-slate-400">Primer Oficial · Iberia Virtual</p></div><div className="grid size-14 place-items-center rounded-2xl border border-amber-300/30 bg-amber-300/10 text-xl font-bold text-amber-300">AR</div></div><div className="relative mt-8 grid grid-cols-3 gap-4 border-t border-white/[.08] pt-5"><div><p className="text-xs text-slate-500">Horas de vuelo</p><p className="mt-1 text-lg font-semibold text-white">128<span className="text-sm font-normal text-slate-500">h 42m</span></p></div><div><p className="text-xs text-slate-500">Operaciones</p><p className="mt-1 text-lg font-semibold text-white">86</p></div><div><p className="text-xs text-slate-500">Puntos VDA</p><p className="mt-1 text-lg font-semibold text-amber-300">2,480</p></div></div><div className="relative mt-6"><div className="mb-2 flex justify-between text-xs"><span className="text-slate-400">Progreso a Capitán</span><span className="font-medium text-amber-300">68%</span></div><div className="h-2 overflow-hidden rounded-full bg-white/[.08]"><div className="h-full w-[68%] rounded-full bg-gradient-to-r from-amber-500 to-amber-300" /></div><p className="mt-2 text-[11px] text-slate-500">Faltan 47 horas para el siguiente rango</p></div></section>
            <section className="rounded-2xl border border-white/[.09] bg-[#0d1b2d] p-6"><div className="flex items-center justify-between"><div><p className="text-xs font-medium uppercase tracking-[.18em] text-slate-500">Condiciones actuales</p><h2 className="mt-2 text-lg font-semibold text-white">METAR / TAF</h2></div><CloudSun className="size-7 text-amber-300" /></div><div className="mt-5 flex items-end justify-between"><div><p className="text-4xl font-semibold text-white">22°<span className="ml-2 text-base font-normal text-slate-400">Parcialmente nublado</span></p><p className="mt-1 text-xs text-slate-500">Viento 240° · 8 kt · Visibilidad 10 km</p></div><div className="text-right"><p className="text-xs text-slate-500">ICAO</p><p className="font-mono text-lg font-semibold text-amber-300">{searched ? icao : 'LEMD'}</p></div></div><div className="mt-5 flex gap-2"><input value={icao} onChange={(e) => setIcao(e.target.value.toUpperCase())} maxLength={4} aria-label="Código ICAO" className="min-w-0 flex-1 rounded-lg border border-white/[.1] bg-white/[.04] px-3 py-2 text-sm font-mono text-white outline-none placeholder:text-slate-600 focus:border-amber-300/50" /><button onClick={() => setSearched(true)} className="rounded-lg bg-amber-400 px-4 py-2 text-sm font-semibold text-[#07101f] hover:bg-amber-300">Consultar</button></div></section>
          </div>

          <section className="mt-7"><div className="mb-4 flex items-center justify-between"><div><p className="text-xs font-medium uppercase tracking-[.18em] text-slate-500">Accesos rápidos</p><h2 className="mt-1 text-lg font-semibold text-white">Centro de operaciones</h2></div><button className="text-xs font-medium text-slate-500 hover:text-amber-300">Ver todos <ChevronRight className="ml-1 inline size-3" /></button></div><div className="grid grid-cols-2 gap-3 sm:grid-cols-4">{quickLinks.map(({ label, icon: Icon, tone }) => <button key={label} className="group flex items-center gap-3 rounded-xl border border-white/[.08] bg-white/[.025] p-4 text-left transition hover:-translate-y-0.5 hover:border-amber-300/30 hover:bg-white/[.05]"><span className={`grid size-10 place-items-center rounded-xl ${tone === 'amber' ? 'bg-amber-300/10 text-amber-300' : tone === 'blue' ? 'bg-sky-300/10 text-sky-300' : tone === 'purple' ? 'bg-violet-300/10 text-violet-300' : 'bg-emerald-300/10 text-emerald-300'}`}><Icon className="size-5" /></span><span><span className="block text-sm font-medium text-slate-200">{label}</span><span className="mt-0.5 block text-[11px] text-slate-500">Abrir módulo</span></span></button>)}</div></section>

          <div className="mt-7 grid gap-5 xl:grid-cols-[1.35fr_1fr]"><section className="rounded-2xl border border-white/[.09] bg-[#0d1b2d] p-5 sm:p-6"><div className="mb-5 flex items-center justify-between"><div><p className="text-xs font-medium uppercase tracking-[.18em] text-slate-500">Actividad reciente</p><h2 className="mt-1 text-lg font-semibold text-white">Mis últimos vuelos</h2></div><button className="text-xs font-medium text-amber-300">Historial completo</button></div><div className="flex flex-col gap-2">{flights.map((flight) => <div key={flight.number} className="flex items-center gap-3 rounded-xl border border-white/[.06] bg-white/[.02] p-3"><div className="grid size-9 shrink-0 place-items-center rounded-lg bg-slate-800 text-slate-400"><Plane className="size-4" /></div><div className="min-w-0 flex-1"><div className="flex items-center gap-2"><p className="text-sm font-medium text-white">{flight.route}</p><span className={`hidden rounded px-1.5 py-0.5 text-[10px] sm:block ${flight.color === 'green' ? 'bg-emerald-400/10 text-emerald-300' : flight.color === 'amber' ? 'bg-amber-400/10 text-amber-300' : 'bg-red-400/10 text-red-300'}`}>{flight.status}</span></div><p className="mt-1 text-xs text-slate-500">{flight.number} · {flight.aircraft}</p></div><div className="text-right"><p className="text-xs font-medium text-slate-300">{flight.time}</p><p className="mt-1 text-[10px] text-slate-600">09 Oct</p></div></div>)}</div></section><section className="rounded-2xl border border-white/[.09] bg-[#0d1b2d] p-5 sm:p-6"><div className="flex items-center justify-between"><div><p className="text-xs font-medium uppercase tracking-[.18em] text-slate-500">Resumen mensual</p><h2 className="mt-1 text-lg font-semibold text-white">Rendimiento</h2></div><Gauge className="size-5 text-amber-300" /></div><div className="mt-5 grid grid-cols-2 gap-3"><Metric label="Horas voladas" value="18.4 h" delta="+12.5%" up /><Metric label="Millas náuticas" value="6,240 NM" delta="+8.2%" up /><Metric label="Puntos ganados" value="420" delta="+24.0%" up /><Metric label="Aterrizaje medio" value="-148 fpm" delta="Excelente" up={false} /></div></section></div>
        </section>
      </div>
      <nav className="fixed inset-x-0 bottom-0 z-10 flex h-[72px] items-center justify-around border-t border-white/[.08] bg-[#091526]/95 px-4 backdrop-blur-xl lg:hidden" aria-label="Navegación móvil">{[['Inicio', LayoutDashboard], ['Vuelos', Plane], ['Perfil', UserRound]].map(([label, Icon]) => <button key={label as string} onClick={() => setActive(label as string)} className={`flex min-w-20 flex-col items-center gap-1 text-[10px] ${active === label ? 'text-amber-300' : 'text-slate-500'}`}><Icon className="size-5" />{label as string}</button>)}</nav>
    </main>
  )
}

function Metric({ label, value, delta, up }: { label: string; value: string; delta: string; up: boolean }) {
  return <div className="rounded-xl bg-white/[.03] p-3"><p className="text-[11px] text-slate-500">{label}</p><p className="mt-2 text-base font-semibold text-white">{value}</p><p className={`mt-1 flex items-center gap-1 text-[10px] ${up ? 'text-emerald-300' : 'text-amber-300'}`}>{up ? <ArrowUpRight className="size-3" /> : <ArrowDownRight className="size-3" />}{delta}</p></div>
}
