class Hub {
  final int id;
  String name;
  final cover_image;
  final double longitude;
  final double latitude;
  final bool is_full;
  final int limit_parking_slot;
  final int available_parking_slot;
  final int available_bike;

  Hub(
      {required this.id,
      required this.name,
      required this.cover_image,
      required this.longitude,
      required this.latitude,
      required this.is_full,
      required this.limit_parking_slot,
      required this.available_bike,
      required this.available_parking_slot});

  factory Hub.fromJson(Map<String, dynamic> json) => Hub(
      id: json["id"],
      name: json["name"],
      longitude: json["longitude"],
      latitude: json["latitude"],
      cover_image: json["cover_image"],
      is_full: json["is_full"],
      limit_parking_slot: json['limit_parking_slot'],
      available_bike: json['available_bike'],
      available_parking_slot: json['available_parking_slot']);
}
