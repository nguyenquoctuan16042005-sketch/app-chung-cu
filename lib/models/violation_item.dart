class ViolationItem {
  final String id;
  final String apartmentId;

  final String content;
  final String level;
  final DateTime createdAt;

  String handling;
  String status;

  ViolationItem({
    required this.id,
    required this.apartmentId,
    required this.content,
    required this.level,
    required this.createdAt,
    this.handling = 'Chưa xử lý',
    this.status = 'Mới ghi nhận',
  });
}