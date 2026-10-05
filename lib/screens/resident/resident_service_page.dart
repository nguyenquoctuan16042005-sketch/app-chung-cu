import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/formatters.dart';
import '../../data/app_repository.dart';
import '../../models/service_item.dart';
import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';

class ResidentServicePage extends StatelessWidget {
  const ResidentServicePage({super.key});

  void _showRegisterServiceDialog(BuildContext context) {
    final repo = AppRepository.instance;
    final aptId = repo.currentResidentApartmentId;
    final available = repo.services
        .where((s) => !s.apartmentIds.contains(aptId))
        .toList();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Đăng ký dịch vụ mới'),
          content: SizedBox(
            width: 480,
            child: available.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('Bạn đã đăng ký tất cả các dịch vụ hiện có.'),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: available.map((s) {
                      return ListTile(
                        title: Text(s.name),
                        subtitle: Text(
                          '${formatMoney(s.monthlyFee)}/tháng • ${s.description}',
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            s.apartmentIds.add(aptId);
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Đã đăng ký dịch vụ ${s.name}'),
                              ),
                            );
                          },
                          child: const Text('Đăng ký'),
                        ),
                      );
                    }).toList(),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Đóng'),
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
        final registeredServices = repo.servicesForApartment(
          repo.currentResidentApartmentId,
        );

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
                        'Dịch vụ căn hộ đang sử dụng',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Các dịch vụ tiện ích định kỳ được tính vào hóa đơn hàng tháng.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showRegisterServiceDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Đăng ký dịch vụ'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (registeredServices.isEmpty)
              const SectionCard(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'Căn hộ chưa đăng ký dịch vụ nào',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              )
            else
              ...registeredServices.map((service) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: SectionCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child: Icon(
                          _getServiceIcon(service.name),
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        service.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '${formatMoney(service.monthlyFee)}/tháng • ${service.description}',
                      ),
                      trailing: const StatusChip('Đang hoạt động'),
                    ),
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  IconData _getServiceIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('xe máy')) return Icons.motorcycle;
    if (lower.contains('ô tô')) return Icons.directions_car;
    if (lower.contains('vệ sinh')) return Icons.cleaning_services;
    if (lower.contains('bơi') || lower.contains('gym')) {
      return Icons.fitness_center;
    }
    if (lower.contains('thẻ')) return Icons.badge;
    return Icons.miscellaneous_services;
  }
}