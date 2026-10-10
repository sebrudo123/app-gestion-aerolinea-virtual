class Pirep {
  final String id;
  final String route;
  final String pilot;
  final double hours;
  String status;
  final String ac;

  Pirep({
    required this.id,
    required this.route,
    required this.pilot,
    required this.hours,
    required this.status,
    this.ac = 'Airbus A320',
  });
}
