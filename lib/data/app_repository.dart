import 'package:flutter/material.dart';

import '../models/apartment.dart';
import '../models/app_notification.dart';
import '../models/feedback_item.dart';
import '../models/invoice.dart';
import '../models/maintenance_item.dart';
import '../models/payment_request.dart';
import '../models/service_item.dart';
import '../models/violation_item.dart';

class AppRepository extends ChangeNotifier {
  static final AppRepository instance = AppRepository._internal();

  AppRepository._internal();

  String currentResidentApartmentId = 'A-05-01';

  final List<Apartment> _apartments = [
    Apartment(
      id: 'A-05-01',
      building: 'A',
      floor: 5,
      unit: '01',
      ownerName: 'Trần Thu Hà',
      memberCount: 3,
      isVacant: false,
    ),
    Apartment(
      id: 'A-05-02',
      building: 'A',
      floor: 5,
      unit: '02',
      ownerName: 'Nguyễn Văn An',
      memberCount: 4,
      isVacant: false,
    ),
    Apartment(
      id: 'A-08-03',
      building: 'A',
      floor: 8,
      unit: '03',
      ownerName: 'Lê Hoàng Nam',
      memberCount: 2,
      isVacant: false,
    ),
    Apartment(
      id: 'B-12-01',
      building: 'B',
      floor: 12,
      unit: '01',
      ownerName: null,
      memberCount: 0,
      isVacant: true,
    ),
    Apartment(
      id: 'B-12-02',
      building: 'B',
      floor: 12,
      unit: '02',
      ownerName: 'Phạm Minh Đức',
      memberCount: 3,
      isVacant: false,
    ),
    Apartment(
      id: 'A101',
      building: 'A',
      floor: 1,
      unit: '01',
      ownerName: 'Nguyễn Văn An',
      memberCount: 3,
      isVacant: false,
    ),
    Apartment(
      id: 'A102',
      building: 'A',
      floor: 1,
      unit: '02',
      ownerName: 'Trần Văn Bình',
      memberCount: 2,
      isVacant: false,
    ),
  ];

  final List<ServiceItem> _services = [
    ServiceItem(
      id: 'SV001',
      name: 'Phí quản lý vận hành',
      description: 'Bảo trì tòa nhà, chiếu sáng công cộng, vệ sinh chung',
      monthlyFee: 800000.0,
      active: true,
      apartmentIds: {'A-05-01', 'A-05-02', 'A-08-03', 'B-12-02', 'A101', 'A102'},
    ),
    ServiceItem(
      id: 'SV002',
      name: 'Gửi xe máy',
      description: 'Dịch vụ trông giữ xe máy tại hầm B1',
      monthlyFee: 120000.0,
      active: true,
      apartmentIds: {'A-05-01', 'A-05-02', 'A101'},
    ),
    ServiceItem(
      id: 'SV003',
      name: 'Gửi ô tô',
      description: 'Dịch vụ trông giữ ô tô tại hầm B2',
      monthlyFee: 1200000.0,
      active: true,
      apartmentIds: {'A-05-01', 'B-12-02'},
    ),
    ServiceItem(
      id: 'SV004',
      name: 'Vệ sinh căn hộ',
      description: 'Dịch vụ dọn dẹp vệ sinh căn hộ theo yêu cầu',
      monthlyFee: 500000.0,
      active: true,
      apartmentIds: {'A-05-01'},
    ),
  ];

  final List<Invoice> _invoices = [
    Invoice(
      id: 'HD-2026-10-001',
      apartmentId: 'A-05-01',
      period: 'Tháng 10/2026',
      items: [
        InvoiceLine(
          name: 'Phí quản lý vận hành',
          quantity: 1,
          unit: 'tháng',
          unitPrice: 800000,
        ),
        InvoiceLine(
          name: 'Tiền điện sinh hoạt',
          quantity: 1,
          unit: 'kỳ',
          unitPrice: 450000,
        ),
        InvoiceLine(
          name: 'Tiền nước sinh hoạt',
          quantity: 1,
          unit: 'kỳ',
          unitPrice: 200000,
        ),
      ],
      paid: 0,
      dueDate: DateTime(2026, 10, 10),
    ),
    Invoice(
      id: 'HD-2026-10-002',
      apartmentId: 'A-05-02',
      period: 'Tháng 10/2026',
      items: [
        InvoiceLine(
          name: 'Phí quản lý vận hành',
          quantity: 1,
          unit: 'tháng',
          unitPrice: 800000,
        ),
        InvoiceLine(
          name: 'Tiền điện sinh hoạt',
          quantity: 1,
          unit: 'kỳ',
          unitPrice: 650000,
        ),
      ],
      paid: 1450000,
      dueDate: DateTime(2026, 10, 10),
    ),
    Invoice(
      id: 'HD-2026-09-001',
      apartmentId: 'A-05-01',
      period: 'Tháng 09/2026',
      items: [
        InvoiceLine(
          name: 'Phí quản lý vận hành',
          quantity: 1,
          unit: 'tháng',
          unitPrice: 800000,
        ),
        InvoiceLine(
          name: 'Tiền điện sinh hoạt',
          quantity: 1,
          unit: 'kỳ',
          unitPrice: 550000,
        ),
      ],
      paid: 1350000,
      dueDate: DateTime(2026, 9, 10),
    ),
  ];

  final List<PaymentRequest> _paymentRequests = [
    PaymentRequest(
      id: 'PR001',
      invoiceId: 'HD-2026-10-001',
      amount: 1450000,
      method: 'Chuyển khoản',
      transactionCode: 'FT2627918239',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'Chờ xác nhận',
    ),
  ];

  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'NT001',
      title: 'Thông báo thu phí tháng 10/2026',
      message:
          'Ban quản lý xin thông báo kỳ thu phí dịch vụ tháng 10/2026. Vui lòng thanh toán trước ngày 10/10.',
      createdAt: DateTime(2026, 10, 1),
      isRead: false,
    ),
    AppNotification(
      id: 'NT002',
      title: 'Lịch bảo trì thang máy Tòa A',
      message:
          'Thang máy số 2 Tòa A sẽ được bảo trì định kỳ vào 09:00 - 11:00 ngày 08/10/2026.',
      createdAt: DateTime(2026, 10, 3),
      isRead: false,
    ),
    AppNotification(
      id: 'NT003',
      title: 'Nhắc nhở vệ sinh hành lang',
      message:
          'Kính đề nghị cư dân không để đồ đạc cá nhân ngoài hành lang chung.',
      createdAt: DateTime(2026, 9, 28),
      isRead: true,
    ),
  ];

  final List<FeedbackItem> _feedbacks = [
    FeedbackItem(
      id: 'PA001',
      apartmentId: 'A-05-01',
      title: 'Đèn hành lang bị hỏng',
      type: 'Kỹ thuật',
      priority: 'Cao',
      content: 'Bóng đèn gần căn A-05-01 nhấp nháy từ tối qua.',
      createdAt: DateTime(2026, 10, 4),
      status: 'Đang xử lý',
      assignedTo: 'Kỹ thuật viên Nam',
    ),
    FeedbackItem(
      id: 'PA002',
      apartmentId: 'A102',
      title: 'Khu giữ xe chưa sạch',
      type: 'Vệ sinh',
      priority: 'Trung bình',
      content: 'Khu vực gửi xe máy B1 có nhiều bụi bẩn.',
      createdAt: DateTime(2026, 10, 2),
      status: 'Mới tiếp nhận',
    ),
  ];

  final List<ViolationItem> _violations = [
    ViolationItem(
      id: 'VP001',
      apartmentId: 'A-08-03',
      content: 'Gây tiếng ồn sau 22h',
      level: 'Nhắc nhở',
      createdAt: DateTime(2026, 10, 2),
      handling: 'Đã lập biên bản nhắc nhở lần 1',
      status: 'Đang xử lý',
    ),
    ViolationItem(
      id: 'VP002',
      apartmentId: 'B-12-02',
      content: 'Để đồ tại hành lang chung',
      level: 'Yêu cầu khắc phục',
      createdAt: DateTime(2026, 9, 29),
      handling: 'Đã di dời vật dụng',
      status: 'Hoàn thành',
    ),
  ];

  final List<MaintenanceItem> _maintenances = [
    MaintenanceItem(
      id: 'BT001',
      equipment: 'Thang máy Block A',
      location: 'Tòa A',
      type: 'Bảo trì định kỳ',
      scheduledDate: DateTime(2026, 10, 8),
      employee: 'Nguyễn Văn Minh',
      status: 'Chờ thực hiện',
    ),
    MaintenanceItem(
      id: 'BT002',
      equipment: 'Máy bơm nước tầng hầm',
      location: 'Tầng hầm B2',
      type: 'Sửa chữa',
      scheduledDate: DateTime(2026, 10, 5),
      employee: 'Trần Đình Trọng',
      result: 'Đã thay van áp suất',
      status: 'Hoàn thành',
    ),
  ];

  // Getters
  List<Apartment> get apartments => List.unmodifiable(_apartments);
  List<ServiceItem> get services => List.unmodifiable(_services);
  List<Invoice> get invoices => List.unmodifiable(_invoices);
  List<PaymentRequest> get paymentRequests => List.unmodifiable(_paymentRequests);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  List<FeedbackItem> get feedbacks => List.unmodifiable(_feedbacks);
  List<ViolationItem> get violations => List.unmodifiable(_violations);
  List<MaintenanceItem> get maintenances => List.unmodifiable(_maintenances);

  int get totalMembers {
    int total = 0;
    for (final apt in _apartments) {
      if (!apt.isVacant) {
        total += apt.memberCount;
      }
    }
    return total;
  }

  int get unreadNotifications {
    return _notifications.where((n) => !n.isRead).length;
  }

  // Apartment operations
  Apartment? getApartmentById(String id) {
    try {
      return _apartments.firstWhere((apt) => apt.id == id);
    } catch (_) {
      if (_apartments.isNotEmpty) return _apartments.first;
      return null;
    }
  }

  void addApartment(Apartment apt) {
    _apartments.add(apt);
    notifyListeners();
  }

  void updateApartment(Apartment apt) {
    final index = _apartments.indexWhere((a) => a.id == apt.id);
    if (index != -1) {
      _apartments[index] = apt;
      notifyListeners();
    }
  }

  void deleteApartment(String id) {
    _apartments.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  // Service operations
  List<ServiceItem> servicesForApartment(String apartmentId) {
    return _services.where((s) => s.apartmentIds.contains(apartmentId)).toList();
  }

  List<ServiceItem> availableServicesForApartment(String apartmentId) {
    return _services
        .where((s) => !s.apartmentIds.contains(apartmentId) && s.active)
        .toList();
  }

  void registerService({
    required String serviceId,
    required String apartmentId,
  }) {
    final index = _services.indexWhere((s) => s.id == serviceId);
    if (index != -1) {
      _services[index].apartmentIds.add(apartmentId);
      notifyListeners();
    }
  }

  void unregisterService({
    required String serviceId,
    required String apartmentId,
  }) {
    final index = _services.indexWhere((s) => s.id == serviceId);
    if (index != -1) {
      _services[index].apartmentIds.remove(apartmentId);
      notifyListeners();
    }
  }

  void createService({
    required String name,
    required String description,
    required double monthlyFee,
  }) {
    final newId = 'SV${(_services.length + 1).toString().padLeft(3, '0')}';
    final newService = ServiceItem(
      id: newId,
      name: name,
      description: description,
      monthlyFee: monthlyFee,
      active: true,
    );
    _services.add(newService);
    notifyListeners();
  }

  // Invoice & Payment operations
  List<Invoice> invoicesForApartment(String apartmentId) {
    final list = _invoices.where((i) => i.apartmentId == apartmentId).toList();
    if (list.isEmpty && _invoices.isNotEmpty) {
      return _invoices;
    }
    return list;
  }

  void addInvoice(Invoice invoice) {
    _invoices.add(invoice);
    notifyListeners();
  }

  void createPaymentRequest({
    required String invoiceId,
    required double amount,
    required String method,
    required String transactionCode,
  }) {
    final newId = 'PR${(_paymentRequests.length + 1).toString().padLeft(3, '0')}';
    final req = PaymentRequest(
      id: newId,
      invoiceId: invoiceId,
      amount: amount,
      method: method,
      transactionCode: transactionCode,
      createdAt: DateTime.now(),
      status: 'Chờ xác nhận',
    );
    _paymentRequests.add(req);
    notifyListeners();
  }

  void confirmPaymentRequest(String requestId) {
    final reqIndex = _paymentRequests.indexWhere((r) => r.id == requestId);
    if (reqIndex != -1) {
      _paymentRequests[reqIndex].status = 'Đã duyệt';
      final invIndex =
          _invoices.indexWhere((i) => i.id == _paymentRequests[reqIndex].invoiceId);
      if (invIndex != -1) {
        _invoices[invIndex].paid += _paymentRequests[reqIndex].amount;
      }
      notifyListeners();
    }
  }

  void rejectPaymentRequest(String requestId) {
    final reqIndex = _paymentRequests.indexWhere((r) => r.id == requestId);
    if (reqIndex != -1) {
      _paymentRequests[reqIndex].status = 'Từ chối';
      notifyListeners();
    }
  }

  // Notification operations
  void markNotificationRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsRead() {
    for (final notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }
}