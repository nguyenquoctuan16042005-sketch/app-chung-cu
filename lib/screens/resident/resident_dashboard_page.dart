import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/formatters.dart';
import '../../data/app_repository.dart';
import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';
import 'notification_page.dart';

class ResidentDashboardPage extends StatelessWidget {
  final ValueChanged<int>? onNavigateTab;

  const ResidentDashboardPage({
    super.key,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final repo = AppRepository.instance;

    return AnimatedBuilder(
      animation: repo,
      builder: (context, _) {
        final apartment = repo.getApartmentById(
          repo.currentResidentApartmentId,
        );

        final invoices = repo.invoicesForApartment(
          repo.currentResidentApartmentId,
        );

        final unpaid = invoices.where((e) => e.debt > 0);

        final current = unpaid.isNotEmpty ? unpaid.first : null;

        final services = repo.servicesForApartment(
          repo.currentResidentApartmentId,
        );

        final width = MediaQuery.of(context).size.width;

        final mobile = width < 850;

        if (mobile) {
          return _mobile(
            context,
            apartment,
            current,
            services,
          );
        }

        return _desktop(
          context,
          apartment,
          current,
          services,
        );
      },
    );
  }

  Widget _desktop(
    BuildContext context,
    dynamic apartment,
    dynamic invoice,
    List services,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(40, 30, 40, 45),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chào buổi sáng, ${apartment?.ownerName ?? "Thu Hà"} 👋',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Căn hộ ${apartment?.displayCode ?? "A-05-01"} · Cập nhật hôm nay',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const StatusChip(
              'Căn hộ hoạt động bình thường',
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Payment hero & Year status
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 950) {
              return Column(
                children: [
                  _paymentHero(context, invoice),
                  const SizedBox(height: 18),
                  _yearCard(),
                ],
              );
            }

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: _paymentHero(
                      context,
                      invoice,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _yearCard(),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        // 4 Quick Actions in Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth < 1100 ? 2 : 4;

            return GridView.count(
              crossAxisCount: count,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: count == 4 ? 2.6 : 3.2,
              children: [
                _quickAction(
                  Icons.receipt_long_outlined,
                  AppColors.primary,
                  'Phí dịch vụ',
                  'Xem và thanh toán hóa đơn',
                  () => onNavigateTab?.call(1),
                ),
                _quickAction(
                  Icons.calendar_month_outlined,
                  AppColors.success,
                  'Đăng ký dịch vụ',
                  'Vệ sinh, nước uống, gửi xe',
                  () => onNavigateTab?.call(2),
                ),
                _quickAction(
                  Icons.message_outlined,
                  AppColors.warning,
                  'Gửi phản ánh',
                  'Theo dõi phản hồi Ban quản lý',
                  () => onNavigateTab?.call(3),
                ),
                _quickAction(
                  Icons.build_outlined,
                  AppColors.primary,
                  'Yêu cầu bảo trì',
                  'Báo sự cố trong căn hộ',
                  () => onNavigateTab?.call(3),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        // Services & Notifications
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 950) {
              return Column(
                children: [
                  _servicesCard(services),
                  const SizedBox(height: 20),
                  _notificationsCard(context),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _servicesCard(
                    services,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _notificationsCard(context),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _mobile(
    BuildContext context,
    dynamic apartment,
    dynamic invoice,
    List services,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      children: [
        Text(
          'Chào buổi sáng, ${apartment?.ownerName ?? "Thu Hà"} 👋',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          'Căn hộ ${apartment?.displayCode ?? "A-05-01"} · Tòa ${apartment?.building ?? "A"}',
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 18),

        _paymentHero(
          context,
          invoice,
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            Expanded(
              child: _mobileAction(
                Icons.receipt_long_outlined,
                AppColors.primary,
                'Phí DV',
                () => onNavigateTab?.call(1),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _mobileAction(
                Icons.calendar_month_outlined,
                AppColors.success,
                'Dịch vụ',
                () => onNavigateTab?.call(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _mobileAction(
                Icons.message_outlined,
                AppColors.warning,
                'Phản ánh',
                () => onNavigateTab?.call(3),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _mobileAction(
                Icons.build_outlined,
                AppColors.primary,
                'Bảo trì',
                () => onNavigateTab?.call(3),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _servicesCard(services),

        const SizedBox(height: 18),

        _notificationsCard(context),
      ],
    );
  }

  Widget _paymentHero(
    BuildContext context,
    dynamic invoice,
  ) {
    final double amount = (invoice?.debt as num?)?.toDouble() ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Phí cần thanh toán · ${invoice?.period ?? "Tháng 10/2026"}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '● Hạn 10/10/2026',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            formatMoney(amount),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (invoice != null && invoice.items != null)
            Text(
              (invoice.items as List)
                  .take(2)
                  .map(
                    (e) => '${e.name}: ${formatMoney(e.amount)}',
                  )
                  .join('   •   '),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  onNavigateTab?.call(1);
                },
                child: const Text(
                  'Thanh toán ngay',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.white54,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  if (invoice != null) {
                    _showInvoiceModal(context, invoice);
                  } else {
                    onNavigateTab?.call(1);
                  }
                },
                child: const Text(
                  'Xem chi tiết hóa đơn',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showInvoiceModal(BuildContext context, dynamic invoice) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Hóa đơn ${invoice.period}'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...((invoice.items as List?) ?? []).map((item) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.name.toString()),
                      subtitle: Text(
                        '${item.quantity} ${item.unit} × ${formatMoney(item.unitPrice)}',
                      ),
                      trailing: Text(
                        formatMoney(item.amount),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng tiền:',
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
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Đóng'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                onNavigateTab?.call(1);
              },
              child: const Text('Đi tới thanh toán'),
            ),
          ],
        );
      },
    );
  }

  Widget _yearCard() {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Tình hình năm 2026',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Đã thanh toán đúng hạn 8/9 kỳ',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            '89%',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          LinearProgressIndicator(
            value: 0.89,
            minHeight: 8,
            color: AppColors.success,
            backgroundColor: const Color(0xFFEDF1F5),
            borderRadius: BorderRadius.circular(20),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _yearMini(
                  'Đã thanh toán',
                  '12,8 triệu',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _yearMini(
                  'Sắp tới',
                  '1,42 triệu',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _yearMini(
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(
    IconData icon,
    Color color,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: SectionCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _iconBox(icon, color),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _mobileAction(
    IconData icon,
    Color color,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SectionCard(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 6,
        ),
        child: Column(
          children: [
            _iconBox(icon, color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBox(
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _servicesCard(
    List services,
  ) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dịch vụ đang dùng',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Các dịch vụ định kỳ đang hoạt động',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              OutlinedButton(
                onPressed: () => onNavigateTab?.call(2),
                child: const Text('Xem tất cả'),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (services.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Chưa có dịch vụ nào đăng ký',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ...services.take(3).map(
              (service) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _iconBox(
                        Icons.cleaning_services_outlined,
                        AppColors.success,
                      ),
                      title: Text(
                        service.name.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${formatMoney(service.monthlyFee)}/tháng',
                      ),
                      trailing: const StatusChip(
                        'Hoạt động',
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _notificationsCard(BuildContext context) {
    final repo = AppRepository.instance;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Thông báo mới',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationPage(),
                    ),
                  );
                },
                child: const Text('Xem tất cả'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (repo.notifications.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Không có thông báo nào',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ...repo.notifications.take(3).map(
              (notification) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _iconBox(
                    Icons.notifications_none,
                    AppColors.warning,
                  ),
                  title: Text(
                    notification.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    repo.markNotificationRead(notification.id);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}