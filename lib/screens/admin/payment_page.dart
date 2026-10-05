import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/formatters.dart';
import '../../data/app_repository.dart';
import '../../models/invoice.dart';
import '../../models/payment_request.dart';
import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showInvoiceDetail(BuildContext context, Invoice invoice) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text('Hóa đơn ${invoice.id}'),
          content: SizedBox(
            width: 550,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Căn hộ: ${invoice.apartmentId}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      StatusChip(invoice.status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kỳ thu: ${invoice.period}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Chi tiết các mục phí',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ...invoice.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${item.quantity} ${item.unit} × ${formatMoney(item.unitPrice)}',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formatMoney(item.amount),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng số tiền:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatMoney(invoice.total),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Đã thanh toán:'),
                      Text(
                        formatMoney(invoice.paid),
                        style: const TextStyle(color: AppColors.success),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Còn nợ:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatMoney(invoice.debt),
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateInvoiceDialog(BuildContext context) {
    final repo = AppRepository.instance;
    final aptController = TextEditingController(
      text: repo.apartments.isNotEmpty ? repo.apartments.first.id : 'A101',
    );
    final periodController = TextEditingController(text: 'Tháng 10/2026');
    final feeController = TextEditingController(text: '800000');
    final electricityController = TextEditingController(text: '450000');
    final waterController = TextEditingController(text: '200000');

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Tạo hóa đơn thu phí mới'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: aptController.text,
                    decoration: const InputDecoration(labelText: 'Căn hộ'),
                    items: repo.apartments.map((a) {
                      return DropdownMenuItem(
                        value: a.id,
                        child: Text('${a.displayCode} (${a.ownerName ?? "Trống"})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        aptController.text = val;
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: periodController,
                    decoration: const InputDecoration(
                      labelText: 'Kỳ thu phí',
                      hintText: 'VD: Tháng 10/2026',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: feeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Phí quản lý vận hành',
                      suffixText: 'VNĐ',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: electricityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Tiền điện',
                      suffixText: 'VNĐ',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: waterController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Tiền nước',
                      suffixText: 'VNĐ',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final aptId = aptController.text.trim();
                final period = periodController.text.trim();
                final fee = double.tryParse(feeController.text.trim()) ?? 0;
                final elec =
                    double.tryParse(electricityController.text.trim()) ?? 0;
                final water =
                    double.tryParse(waterController.text.trim()) ?? 0;

                final items = <InvoiceLine>[];
                if (fee > 0) {
                  items.add(
                    InvoiceLine(
                      name: 'Phí quản lý vận hành',
                      quantity: 1,
                      unit: 'tháng',
                      unitPrice: fee,
                    ),
                  );
                }
                if (elec > 0) {
                  items.add(
                    InvoiceLine(
                      name: 'Tiền điện sinh hoạt',
                      quantity: 1,
                      unit: 'kỳ',
                      unitPrice: elec,
                    ),
                  );
                }
                if (water > 0) {
                  items.add(
                    InvoiceLine(
                      name: 'Tiền nước sinh hoạt',
                      quantity: 1,
                      unit: 'kỳ',
                      unitPrice: water,
                    ),
                  );
                }

                final newId =
                    'HD-${DateTime.now().year}-${DateTime.now().month}-${(repo.invoices.length + 1).toString().padLeft(3, '0')}';

                final newInv = Invoice(
                  id: newId,
                  apartmentId: aptId,
                  period: period,
                  items: items,
                  paid: 0,
                  dueDate: DateTime.now().add(const Duration(days: 10)),
                );

                repo.addInvoice(newInv);
                Navigator.pop(dialogCtx);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã tạo hóa đơn $newId'),
                  ),
                );
              },
              child: const Text('Tạo hóa đơn'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = AppRepository.instance;

    return AnimatedBuilder(
      animation: repo,
      builder: (_, __) {
        final double totalRevenue =
            repo.invoices.fold<double>(0.0, (sum, i) => sum + i.total);
        final double paidRevenue =
            repo.invoices.fold<double>(0.0, (sum, i) => sum + i.paid);
        final double debtRevenue =
            repo.invoices.fold<double>(0.0, (sum, i) => sum + i.debt);
        final pendingRequests = repo.paymentRequests
            .where((p) => p.status == 'Chờ xác nhận')
            .length;

        final query = _searchController.text.trim().toLowerCase();
        final filteredInvoices = repo.invoices.where((inv) {
          final matchesQuery = query.isEmpty ||
              inv.id.toLowerCase().contains(query) ||
              inv.apartmentId.toLowerCase().contains(query) ||
              inv.period.toLowerCase().contains(query);

          final matchesStatus = _selectedStatus == 'Tất cả' ||
              inv.status == _selectedStatus;

          return matchesQuery && matchesStatus;
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(26),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thanh toán phí dịch vụ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Quản lý hóa đơn định kỳ, tiến độ thu phí và xét duyệt thanh toán.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCreateInvoiceDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Tạo hóa đơn'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Stat Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final count = constraints.maxWidth < 700
                    ? 2
                    : (constraints.maxWidth < 1100 ? 2 : 4);
                return GridView.count(
                  crossAxisCount: count,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: count == 4 ? 2.2 : 2.0,
                  children: [
                    _statCard(
                      'Tổng phải thu',
                      formatMoney(totalRevenue),
                      Icons.account_balance_wallet_outlined,
                      AppColors.primary,
                    ),
                    _statCard(
                      'Đã thu',
                      formatMoney(paidRevenue),
                      Icons.check_circle_outline,
                      AppColors.success,
                    ),
                    _statCard(
                      'Còn nợ',
                      formatMoney(debtRevenue),
                      Icons.error_outline,
                      AppColors.danger,
                    ),
                    _statCard(
                      'Chờ duyệt TT',
                      '$pendingRequests yêu cầu',
                      Icons.hourglass_top_outlined,
                      AppColors.warning,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 22),

            // Tab bar
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(
                    child: Text('Danh sách hóa đơn (${repo.invoices.length})'),
                  ),
                  Tab(
                    child: Text(
                      'Yêu cầu thanh toán ($pendingRequests chờ duyệt)',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              height: 550,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Invoices
                  Column(
                    children: [
                      SectionCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (_) => setState(() {}),
                                decoration: const InputDecoration(
                                  hintText:
                                      'Tìm kiếm theo mã HĐ, căn hộ, kỳ phí...',
                                  prefixIcon: Icon(Icons.search, size: 20),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            DropdownButton<String>(
                              value: _selectedStatus,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Tất cả',
                                  child: Text('Tất cả trạng thái'),
                                ),
                                DropdownMenuItem(
                                  value: 'Đã thanh toán',
                                  child: Text('Đã thanh toán'),
                                ),
                                DropdownMenuItem(
                                  value: 'Thanh toán một phần',
                                  child: Text('Thanh toán một phần'),
                                ),
                                DropdownMenuItem(
                                  value: 'Chưa thanh toán',
                                  child: Text('Chưa thanh toán'),
                                ),
                                DropdownMenuItem(
                                  value: 'Quá hạn',
                                  child: Text('Quá hạn'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedStatus = val;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: SectionCard(
                          padding: EdgeInsets.zero,
                          child: filteredInvoices.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Không tìm thấy hóa đơn nào',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('Mã HĐ')),
                                      DataColumn(label: Text('Căn hộ')),
                                      DataColumn(label: Text('Kỳ phí')),
                                      DataColumn(label: Text('Tổng tiền')),
                                      DataColumn(label: Text('Đã nộp')),
                                      DataColumn(label: Text('Còn lại')),
                                      DataColumn(label: Text('Trạng thái')),
                                      DataColumn(label: Text('Chi tiết')),
                                    ],
                                    rows: filteredInvoices.map((inv) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              inv.id,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(inv.apartmentId)),
                                          DataCell(Text(inv.period)),
                                          DataCell(Text(formatMoney(inv.total))),
                                          DataCell(
                                            Text(
                                              formatMoney(inv.paid),
                                              style: const TextStyle(
                                                color: AppColors.success,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              formatMoney(inv.debt),
                                              style: TextStyle(
                                                color: inv.debt > 0
                                                    ? AppColors.danger
                                                    : AppColors.textSecondary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataCell(StatusChip(inv.status)),
                                          DataCell(
                                            IconButton(
                                              icon: const Icon(
                                                Icons.visibility_outlined,
                                                size: 18,
                                              ),
                                              onPressed: () =>
                                                  _showInvoiceDetail(
                                                context,
                                                inv,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),

                  // Tab 2: Payment Requests
                  SectionCard(
                    padding: EdgeInsets.zero,
                    child: repo.paymentRequests.isEmpty
                        ? const Center(
                            child: Text(
                              'Chưa có yêu cầu thanh toán nào',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Mã YC')),
                                DataColumn(label: Text('Mã HĐ')),
                                DataColumn(label: Text('Số tiền')),
                                DataColumn(label: Text('Phương thức')),
                                DataColumn(label: Text('Mã giao dịch')),
                                DataColumn(label: Text('Thời gian')),
                                DataColumn(label: Text('Trạng thái')),
                                DataColumn(label: Text('Hành động')),
                              ],
                              rows: repo.paymentRequests.map((req) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        req.id,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(req.invoiceId)),
                                    DataCell(
                                      Text(
                                        formatMoney(req.amount),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(req.method)),
                                    DataCell(
                                      Text(
                                        req.transactionCode.isEmpty
                                            ? '-'
                                            : req.transactionCode,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        '${req.createdAt.day}/${req.createdAt.month} ${req.createdAt.hour}:${req.createdAt.minute.toString().padLeft(2, '0')}',
                                      ),
                                    ),
                                    DataCell(StatusChip(req.status)),
                                    DataCell(
                                      req.status == 'Chờ xác nhận'
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.success,
                                                    padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    repo.confirmPaymentRequest(
                                                      req.id,
                                                    );
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Đã duyệt yêu cầu thanh toán ${req.id}',
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text('Duyệt'),
                                                ),
                                                const SizedBox(width: 8),
                                                OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    repo.rejectPaymentRequest(
                                                      req.id,
                                                    );
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Đã từ chối yêu cầu thanh toán ${req.id}',
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text('Từ chối'),
                                                ),
                                              ],
                                            )
                                          : const Text(
                                              'Đã xử lý',
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return SectionCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}