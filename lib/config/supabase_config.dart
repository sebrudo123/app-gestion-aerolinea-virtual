class SupabaseConfig {
  static const String url = 'https://YOUR-PROJECT.supabase.co';
  static const String anonKey = 'YOUR-ANON-KEY';

  static bool get enabled =>
      !url.contains('YOUR-PROJECT') && !anonKey.startsWith('YOUR-');
}