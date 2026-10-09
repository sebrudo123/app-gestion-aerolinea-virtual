// @ts-nocheck
import { Tabs } from 'expo-router'
import { Home, Plane, UserRound } from 'lucide-react-native'

export default function TabsLayout() {
  return <Tabs screenOptions={{ headerShown: false, tabBarActiveTintColor: '#e7bf72', tabBarInactiveTintColor: '#8591a5', tabBarStyle: { backgroundColor: '#101b2e', borderTopColor: '#243958', height: 68, paddingBottom: 10 }, tabBarLabelStyle: { fontSize: 12 } }}>
    <Tabs.Screen name="index" options={{ title: 'Inicio', tabBarIcon: ({ color, size }) => <Home color={color} size={size} /> }} />
    <Tabs.Screen name="flights" options={{ title: 'Vuelos', tabBarIcon: ({ color, size }) => <Plane color={color} size={size} /> }} />
    <Tabs.Screen name="profile" options={{ title: 'Perfil', tabBarIcon: ({ color, size }) => <UserRound color={color} size={size} /> }} />
  </Tabs>
}
