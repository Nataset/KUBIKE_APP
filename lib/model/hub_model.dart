class Hub {
  final String name;
  final double lon;
  final double lat;

  Hub({required this.name, required this.lon, required this.lat});

  factory Hub.fromJson(Map<String, dynamic> json) =>
      Hub(name: json["name"], lon: json["longitude"], lat: json["latitude"]);
}
