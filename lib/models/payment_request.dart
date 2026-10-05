class PaymentRequest {
  final String id;
  final String invoiceId;

  final double amount;
  final String method;
  final String transactionCode;

  final DateTime createdAt;

  String status;

  PaymentRequest({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.method,
    required this.transactionCode,
    required this.createdAt,
    this.status = 'Chờ xác nhận',
  });
}