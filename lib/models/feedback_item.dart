class FeedbackItem {
  final String id;
  final String apartmentId;

  final String title;
  final String type;
  final String priority;
  final String content;

  final DateTime createdAt;

  String status;
  String assignedTo;
  String result;

  FeedbackItem({
    required this.id,
    required this.apartmentId,
    required this.title,
    required this.type,
    required this.priority,
    required this.content,
    required this.createdAt,
    this.status = 'Mới tiếp nhận',
    this.assignedTo = '',
    this.result = '',
  });
}