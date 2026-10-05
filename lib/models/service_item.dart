class ServiceItem {
  final String id;

  String name;
  String description;
  double monthlyFee;
  bool active;

  final Set<String> apartmentIds;

  ServiceItem({
    required this.id,
    required this.name,
    required this.description,
    required this.monthlyFee,
    this.active = true,
    Set<String>? apartmentIds,
  }) : apartmentIds = apartmentIds ?? {};

  int get totalRegistered => apartmentIds.length;
}