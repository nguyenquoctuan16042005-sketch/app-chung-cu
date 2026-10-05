class Apartment {
  final String id;
  final String building;
  final int floor;
  final String unit;

  String? ownerName;
  int memberCount;
  bool isVacant;

  Apartment({
    required this.id,
    required this.building,
    required this.floor,
    required this.unit,
    this.ownerName,
    this.memberCount = 0,
    this.isVacant = true,
  });

  String get displayCode {
    return '$building-${floor.toString().padLeft(2, '0')}-$unit';
  }

  String get location {
    return 'Tòa $building • Tầng $floor';
  }
}