import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/formatters.dart';
import '../../data/app_repository.dart';
import '../../models/service_item.dart';
import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';

class ServiceManagementPage
    extends StatelessWidget {
  const ServiceManagementPage({
    super.key,
  });

  void showCreateService(
    BuildContext context,
  ) {
    final nameController =
        TextEditingController();

    final descriptionController =
        TextEditingController();

    final feeController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text('Tạo dịch vụ mới'),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                TextField(
                  controller:
                      nameController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Tên dịch vụ',
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller:
                      descriptionController,
                  decoration:
                      const InputDecoration(
                    labelText: 'Mô tả',
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller:
                      feeController,
                  keyboardType:
                      TextInputType.number,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Phí hàng tháng',
                    suffixText: 'VNĐ',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final fee =
                    double.tryParse(
                          feeController
                              .text,
                        ) ??
                        0;

                if (nameController
                    .text
                    .trim()
                    .isEmpty) {
                  return;
                }

                AppRepository.instance
                    .createService(
                  name: nameController
                      .text
                      .trim(),
                  description:
                      descriptionController
                          .text
                          .trim(),
                  monthlyFee: fee,
                );

                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Tạo dịch vụ',
              ),
            ),
          ],
        );
      },
    );
  }

  void showServiceDetail(
    BuildContext context,
    ServiceItem service,
  ) {
    final repo = AppRepository.instance;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(service.name),
          content: SizedBox(
            width: 520,
            height: 400,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  service.description,
                  style: const TextStyle(
                    color: AppColors
                        .textSecondary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Phí: ${formatMoney(service.monthlyFee)}/tháng',
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  'Tổng căn hộ đăng ký: ${service.totalRegistered}',
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const Divider(
                  height: 30,
                ),

                const Text(
                  'Danh sách căn hộ đăng ký',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: service
                          .apartmentIds
                          .isEmpty
                      ? const Center(
                          child: Text(
                            'Chưa có căn hộ đăng ký',
                          ),
                        )
                      : ListView(
                          children: service
                              .apartmentIds
                              .map(
                                (
                                  apartmentId,
                                ) {
                                  final apartment =
                                      repo
                                          .getApartmentById(
                                    apartmentId,
                                  );

                                  return ListTile(
                                    leading:
                                        const Icon(
                                      Icons
                                          .apartment,
                                    ),
                                    title: Text(
                                      apartment
                                              ?.displayCode ??
                                          apartmentId,
                                    ),
                                    subtitle: Text(
                                      apartment
                                              ?.ownerName ??
                                          'Chưa xác định',
                                    ),
                                  );
                                },
                              )
                              .toList(),
                        ),
                ),
              ],
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

  @override
  Widget build(BuildContext context) {
    final repo = AppRepository.instance;

    return AnimatedBuilder(
      animation: repo,
      builder: (_, __) {
        return ListView(
          padding:
              const EdgeInsets.all(26),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'Danh sách dịch vụ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Quản lý các dịch vụ đang cung cấp cho cư dân.',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    showCreateService(
                      context,
                    );
                  },
                  icon:
                      const Icon(Icons.add),
                  label: const Text(
                    'Tạo dịch vụ mới',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SectionCard(
              padding: EdgeInsets.zero,
              child:
                  SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn:
                      false,
                  columns: const [
                    DataColumn(
                      label:
                          Text('Mã DV'),
                    ),
                    DataColumn(
                      label:
                          Text('Dịch vụ'),
                    ),
                    DataColumn(
                      label:
                          Text('Mức phí'),
                    ),
                    DataColumn(
                      label: Text(
                        'Căn hộ đăng ký',
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Trạng thái',
                      ),
                    ),
                    DataColumn(
                      label:
                          Text('Chi tiết'),
                    ),
                  ],
                  rows: repo.services.map(
                    (service) {
                      return DataRow(
                        onSelectChanged: (_) {
                          showServiceDetail(
                            context,
                            service,
                          );
                        },
                        cells: [
                          DataCell(
                            Text(
                              service.id,
                            ),
                          ),
                          DataCell(
                            Column(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  service.name,
                                  style:
                                      const TextStyle(
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
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              formatMoney(
                                service
                                    .monthlyFee,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${service.totalRegistered} căn',
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                          DataCell(
                            StatusChip(
                              service.active
                                  ? 'Đang hoạt động'
                                  : 'Ngừng hoạt động',
                            ),
                          ),
                          DataCell(
                            IconButton(
                              onPressed: () {
                                showServiceDetail(
                                  context,
                                  service,
                                );
                              },
                              icon: const Icon(
                                Icons
                                    .visibility_outlined,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}