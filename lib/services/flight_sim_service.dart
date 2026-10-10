import 'dart:async';
import 'dart:convert';

class RfsState {
  double altitudeFt = 0;
  double speedKts = 0;
  double headingDeg = 0;
  double latitude = 0;
  double longitude = 0;
  double fuelLbs = 0;
  double fuelRemLbs = 0;
  double landingFpm = 0;
  bool connected = false;
  String callsign = 'VTG030';
  String status = 'En tierra';
  DateTime lastUpdate = DateTime.now();
}

class FlightSimService {
  static final FlightSimService _i = FlightSimService._();
  factory FlightSimService() => _i;
  FlightSimService._();

  final StreamController<RfsState> _ctrl = StreamController<RfsState>.broadcast();
  Stream<RfsState> get stream => _ctrl.stream;

  final RfsState state = RfsState();

  void connect() {
    state.connected = true;
    state.status = 'En tierra';
    _emit();
  }

  void updateTelemetry({
    double? altitudeFt,
    double? speedKts,
    double? headingDeg,
    double? latitude,
    double? longitude,
    double? fuelLbs,
    double? fuelRemLbs,
    double? landingFpm,
    String? status,
  }) {
    if (altitudeFt != null) state.altitudeFt = altitudeFt;
    if (speedKts != null) state.speedKts = speedKts;
    if (headingDeg != null) state.headingDeg = headingDeg;
    if (latitude != null) state.latitude = latitude;
    if (longitude != null) state.longitude = longitude;
    if (fuelLbs != null) state.fuelLbs = fuelLbs;
    if (fuelRemLbs != null) state.fuelRemLbs = fuelRemLbs;
    if (landingFpm != null) state.landingFpm = landingFpm;
    if (status != null) state.status = status;
    state.lastUpdate = DateTime.now();
    state.connected = true;
    _emit();
  }

  void _emit() {
    _ctrl.add(state);
  }
}
