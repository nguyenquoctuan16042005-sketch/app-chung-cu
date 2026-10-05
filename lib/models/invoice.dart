class InvoiceLine {
  final String name;
  final double quantity;
  final String unit;
  final double unitPrice;

  InvoiceLine({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
  });

  double get amount {
    return quantity * unitPrice;
  }
}

class Invoice {
  final String id;
  final String apartmentId;
  final String period;
  final List<InvoiceLine> items;

  double paid;
  final DateTime dueDate;

  Invoice({
    required this.id,
    required this.apartmentId,
    required this.period,
    required this.items,
    required this.paid,
    required this.dueDate,
  });

  double get total {
    return items.fold<double>(
      0.0,
      (sum, item) => sum + item.amount,
    );
  }

  double get debt {
    final result = total - paid;

    if (result < 0) {
      return 0.0;
    }

    return result;
  }

  String get status {
    if (debt <= 0) {
      return 'Đã thanh toán';
    }

    if (paid > 0) {
      return 'Thanh toán một phần';
    }

    if (DateTime.now().isAfter(dueDate)) {
      return 'Quá hạn';
    }

    return 'Chưa thanh toán';
  }
}