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
