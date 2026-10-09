import AsyncStorage from '@react-native-async-storage/async-storage'
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL ?? process.env.NEXT_PUBLIC_SUPABASE_URL ?? ''
const supabaseKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY ?? process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ?? process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? ''

export const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: { storage: AsyncStorage, autoRefreshToken: true, persistSession: true, detectSessionInUrl: false },
})

export type AppConfig = { latest_version: string; release_notes: string; apk_download_url: string }
export type PilotProfile = { id: string; callsign: string; full_name: string; rank: string; flight_hours: number; operations: number; points: number; vdollars: number }

export async function fetchAppConfig() {
  const { data, error } = await supabase.from('app_config').select('latest_version, release_notes, apk_download_url').single()
  if (error) throw error
  return data as AppConfig
}

export async function fetchPilotProfile(userId?: string) {
  const query = supabase.from('profiles').select('id, callsign, full_name, rank, flight_hours, operations, points, vdollars')
  const { data, error } = userId ? await query.eq('id', userId).single() : await query.limit(1).single()
  if (error) throw error
  return data as PilotProfile
}
