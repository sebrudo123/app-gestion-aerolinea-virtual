// @ts-nocheck
import { Stack } from 'expo-router'
import { StatusBar } from 'expo-status-bar'
import { VersionGate } from '../src/components/VersionGate'

export default function RootLayout() {
  return <VersionGate><StatusBar style="light" /><Stack screenOptions={{ headerShown: false, contentStyle: { backgroundColor: '#07101f' } }} /></VersionGate>
}
