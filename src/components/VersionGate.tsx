// @ts-nocheck
import { PropsWithChildren, useEffect, useState } from 'react'
import { ActivityIndicator, Linking, Modal, Platform, Pressable, StyleSheet, Text, View } from 'react-native'
import Constants from 'expo-constants'
import { fetchAppConfig, AppConfig } from '../lib/supabase'

export function VersionGate({ children }: PropsWithChildren) {
  const [config, setConfig] = useState<AppConfig | null>(null)
  const [loading, setLoading] = useState(true)
  useEffect(() => { fetchAppConfig().then(setConfig).catch(() => undefined).finally(() => setLoading(false)) }, [])
  const current = Constants.expoConfig?.version ?? '1.0.0'
  const requiresUpdate = !!config && config.latest_version !== current && config.latest_version > current
  return <>
    {children}
    <Modal visible={requiresUpdate} transparent animationType="fade">
      <View style={styles.backdrop}><View style={styles.card}>
        <Text style={styles.kicker}>AEROVIA / ACTUALIZACIÓN</Text><Text style={styles.title}>Nueva versión disponible</Text>
        <Text style={styles.version}>Versión {config?.latest_version}</Text><Text style={styles.notes}>{config?.release_notes || 'Mejoras de estabilidad y nuevas herramientas para pilotos.'}</Text>
        <Pressable accessibilityRole="button" style={styles.button} onPress={() => config?.apk_download_url && Linking.openURL(config.apk_download_url)}><Text style={styles.buttonText}>Actualizar Aplicación</Text></Pressable>
      </View></View>
    </Modal>
    {loading && Platform.OS !== 'web' ? <View style={styles.loader}><ActivityIndicator color="#e7bf72" /></View> : null}
  </>
}
const styles = StyleSheet.create({ backdrop: { flex: 1, backgroundColor: 'rgba(3,8,18,.86)', alignItems: 'center', justifyContent: 'center', padding: 24 }, card: { width: '100%', maxWidth: 440, borderRadius: 24, borderWidth: 1, borderColor: '#41689f', backgroundColor: '#132442', padding: 26, gap: 12, shadowColor: '#000', shadowOpacity: .4, shadowRadius: 20 }, kicker: { color: '#e7bf72', fontSize: 12, fontWeight: '700', letterSpacing: 2 }, title: { color: '#f6f3eb', fontSize: 26, fontWeight: '800' }, version: { color: '#9fc7ff', fontSize: 15, fontWeight: '700' }, notes: { color: '#cad7e9', fontSize: 15, lineHeight: 23 }, button: { marginTop: 8, backgroundColor: '#e7bf72', borderRadius: 14, padding: 15, alignItems: 'center' }, buttonText: { color: '#101b2e', fontWeight: '800' }, loader: { position: 'absolute', inset: 0, alignItems: 'center', justifyContent: 'center', backgroundColor: '#07101f' } as any })
