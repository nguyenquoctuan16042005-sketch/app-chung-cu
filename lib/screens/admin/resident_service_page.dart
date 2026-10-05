import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/formatters.dart';
import '../../data/app_repository.dart';
import '../../models/service_item.dart';
import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';

class ResidentServicePage
    extends StatelessWidget {
  const ResidentServicePage({
    super.key,
  });

  void showAvailableServices(
    BuildContext context,
  ) {
    final repo = AppRepository.instance;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title:
              const Text('Đăng ký dịch vụ'),
          content: SizedBox(
            width: 570,
            height: 430,
            child: AnimatedBuilder(
              animation: repo,
              builder: (_, __) {
                final available =
                    repo.availableServicesForApartment(
                  repo.currentResidentApartmentId,
                );

                if (available.isEmpty) {
                  return const Center(
                    child: Text(
                      'Bạn đã đăng ký tất cả dịch vụ hiện có.',
                    ),
                  );
                }

                return ListView.separated(
                  itemCount:
                      available.length,
                  separatorBuilder:
                      (_, __) =>
                          const Divider(),
                  itemBuilder:
                      (_, index) {
                    final service =
                        available[index];

                    return ListTile(
                      leading:
                          const CircleAvatar(
                        child: Icon(
                          Icons
                              .miscellaneous_services,
                        ),
                      ),
                      title: Text(
                        service.name,
                      ),
                      subtitle: Text(
                        '${service.description}\n${formatMoney(service.monthlyFee)}/tháng',
                      ),
                      isThreeLine: true,
                      trailing:
                          ElevatedButton(
                        onPressed: () {
                          repo.registerService(
                            serviceId:
                                service.id,
                            apartmentId: repo
                                .currentResidentApartmentId,
                          );

                          Navigator.pop(
                            context,
                          );

                          ScaffoldMessenger
                                  .of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Đã đăng ký ${service.name}',
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Đăng ký',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void confirmStopService(
    BuildContext context,
    ServiceItem service,
  ) {
    final repo = AppRepository.instance;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title:
              const Text('Ngừng dịch vụ'),
          content: Text(
            'Bạn có chắc muốn ngừng sử dụng "${service.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                repo.unregisterService(
                  serviceId:
                      service.id,
                  apartmentId: repo
                      .currentResidentApartmentId,
                );

                Navigator.pop(context);
              },
              child: const Text(
                'Xác nhận',
              ),
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
        final apartment =
            repo.getApartmentById(
          repo.currentResidentApartmentId,
        );

        final registered =
            repo.servicesForApartment(
          repo.currentResidentApartmentId,
        );

        return ListView(
          padding:
              const EdgeInsets.all(26),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Text(
                        'Dịch vụ của căn hộ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      Text(
                        apartment
                                ?.displayCode ??
                            '',
                        style:
                            const TextStyle(
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    showAvailableServices(
                      context,
                    );
                  },
                  icon:
                      const Icon(Icons.add),
                  label: const Text(
                    'Đăng ký dịch vụ',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (registered.isEmpty)
              const SectionCard(
                child: Center(
                  child: Padding(
                    padding:
                        EdgeInsets.all(30),
                    child: Text(
                      'Căn hộ chưa đăng ký dịch vụ nào.',
                    ),
                  ),
                ),
              ),

            ...registered.map(
              (service) => Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                child: SectionCard(
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration:
                            BoxDecoration(
                          color: AppColors
                              .primaryLight,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            12,
                          ),
                        ),
                        child: const Icon(
                          Icons
                              .miscellaneous_services,
                          color: AppColors
                              .primary,
                        ),
                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              service.name,
                              style:
                                  const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            Text(
                              service
                                  .description,
                              style:
                                  const TextStyle(
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${formatMoney(service.monthlyFee)}/tháng',
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const StatusChip(
                        'Đang hoạt động',
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      OutlinedButton(
                        onPressed: () {
                          confirmStopService(
                            context,
                            service,
                          );
                        },
                        child: const Text(
                          'Ngừng',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}