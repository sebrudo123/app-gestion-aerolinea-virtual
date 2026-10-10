class AuthConfig {
  // ==========================================================================
  // MICROSOFT / XBOX  (obligatorio para el login real de Xbox)
  // --------------------------------------------------------------------------
  // 1. Entra en https://portal.azure.com -> "Registros de aplicaciones" -> Nuevo.
  // 2. Tipo de cuenta: "Solo cuentas personales de Microsoft".
  // 3. En "Autenticación" -> Agregar plataforma -> "Aplicaciones móviles y de
  //    escritorio" -> URI de redireccionamiento personalizada: vertexairlines://auth
  // 4. Copia el "Id. de aplicación (cliente)" y pégalo abajo.
  // ==========================================================================
  static const String microsoftClientId = 'YOUR-AZURE-CLIENT-ID';

  static const String microsoftTenant = 'consumers';
  static const String redirectScheme = 'vertexairlines';
  static const String redirectPath = 'auth';

  static String get redirectUri => '$redirectScheme://$redirectPath';

  static bool get microsoftConfigured =>
      microsoftClientId.isNotEmpty &&
      microsoftClientId != 'YOUR-AZURE-CLIENT-ID';

  // ==========================================================================
  // STEAM  (opcional: solo para traer tu gamertag y avatar reales)
  // --------------------------------------------------------------------------
  // Obtén una clave gratuita en https://steamcommunity.com/dev/apikey
  // y pégala abajo. Sin clave igual funciona: se vincula el SteamID64.
  // ==========================================================================
  static const String steamApiKey = '';

  static bool get steamApiConfigured => steamApiKey.isNotEmpty;

  static const String steamRealm = 'https://vertexairlines.app';
  static const String steamReturnUrl =
      'https://vertexairlines.app/steam/callback';
}
