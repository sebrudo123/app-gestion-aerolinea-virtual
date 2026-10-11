import 'dart:async';

class DiscordPresenceConfig {
  final String clientId;
  final String largeImage;
  final String smallImage;
  final String state;
  final String details;
  final String largeImageText;
  final String smallImageText;
  final String? joinSecret;
  final String? partyId;
  final int? partySize;
  final int? partyMax;
  final int? startTimestamp;
  final int? endTimestamp;

  const DiscordPresenceConfig({
    required this.clientId,
    this.largeImage = 'skyconnect_large',
    this.smallImage = 'skyconnect_small',
    this.state = 'En SkyConnect',
    this.details = 'Listo para volar',
    this.largeImageText = 'SkyConnect',
    this.smallImageText = 'SkyConnect',
    this.joinSecret,
    this.partyId,
    this.partySize,
    this.partyMax,
    this.startTimestamp,
    this.endTimestamp,
  });
}

class DiscordRichPresenceService {
  static final DiscordRichPresenceService _instance =
      DiscordRichPresenceService._internal();
  factory DiscordRichPresenceService() => _instance;
  DiscordRichPresenceService._internal();

  final StreamController<bool> _connected = StreamController<bool>.broadcast();
  Stream<bool> get connectedStream => _connected.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  DiscordPresenceConfig? _config;
  DiscordPresenceConfig? get config => _config;

  Future<bool> initialize(String clientId) async {
    _config = DiscordPresenceConfig(clientId: clientId);
    _isConnected = true;
    _connected.add(true);
    return true;
  }

  Future<bool> updatePresence({
    String? state,
    String? details,
    String? largeImage,
    String? smallImage,
    String? largeImageText,
    String? smallImageText,
    String? joinSecret,
    String? partyId,
    int? partySize,
    int? partyMax,
    int? startTimestamp,
    int? endTimestamp,
  }) async {
    if (_config == null) return false;
    _config = DiscordPresenceConfig(
      clientId: _config!.clientId,
      largeImage: largeImage ?? _config!.largeImage,
      smallImage: smallImage ?? _config!.smallImage,
      state: state ?? _config!.state,
      details: details ?? _config!.details,
      largeImageText: largeImageText ?? _config!.largeImageText,
      smallImageText: smallImageText ?? _config!.smallImageText,
      joinSecret: joinSecret ?? _config!.joinSecret,
      partyId: partyId ?? _config!.partyId,
      partySize: partySize ?? _config!.partySize,
      partyMax: partyMax ?? _config!.partyMax,
      startTimestamp: startTimestamp ?? _config!.startTimestamp,
      endTimestamp: endTimestamp ?? _config!.endTimestamp,
    );
    return true;
  }

  Future<void> clearPresence() async {
    _config = _config == null
        ? null
        : DiscordPresenceConfig(clientId: _config!.clientId);
  }

  void dispose() {
    _connected.close();
  }
}
