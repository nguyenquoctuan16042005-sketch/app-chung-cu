class MaintenanceItem {
  final String id;

  final String equipment;
  final String location;
  final String type;

  final DateTime scheduledDate;

  String employee;
  String result;
  String status;

  MaintenanceItem({
    required this.id,
    required this.equipment,
    required this.location,
    required this.type,
    required this.scheduledDate,
    this.employee = '',
    this.result = '',
    this.status = 'Chờ thực hiện',
  });
}