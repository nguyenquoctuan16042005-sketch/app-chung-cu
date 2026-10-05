import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/formatters.dart';
import '../../data/app_repository.dart';
import '../../widgets/section_card.dart';

class AdminDashboardPage
    extends StatelessWidget {
  const AdminDashboardPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final repo =
        AppRepository.instance;

    return AnimatedBuilder(
      animation: repo,
      builder: (_, __) {
        return ListView(
          padding:
              const EdgeInsets.fromLTRB(
            30,
            28,
            30,
            40,
          ),
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
                        'Chào buổi sáng, Minh Anh 👋',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Đây là tình hình vận hành Chung cư BlueHome hôm nay.',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.calendar_month,
                  ),
                  label: const Text(
                    '01-31/10/2026',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            LayoutBuilder(
              builder: (
                context,
                constraints,
              ) {
                int count = 4;

                if (constraints.maxWidth <
                    1100) {
                  count = 2;
                }

                if (constraints.maxWidth <
                    600) {
                  count = 1;
                }

                return GridView.count(
                  crossAxisCount: count,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio:
                      count == 1
                          ? 3.0
                          : 1.85,
                  children: [
                    _StatBox(
                      title:
                          'Tổng cư dân',
                      value:
                          '${repo.totalMembers}',
                      icon:
                          Icons.people_outline,
                      color:
                          AppColors.primary,
                      note:
                          '+1,8% tháng này',
                    ),

                    _StatBox(
                      title:
                          'Doanh thu phí',
                      value:
                          formatMoney(
                        repo.invoices
                            .fold<double>(
                          0.0,
                          (
                            sum,
                            invoice,
                          ) {
                            return sum +
                                invoice
                                    .paid;
                          },
                        ),
                      ),
                      icon: Icons
                          .attach_money,
                      color:
                          AppColors.success,
                      note:
                          'Doanh thu đã thu',
                    ),

                    _StatBox(
                      title:
                          'Yêu cầu mở',
                      value: repo.feedbacks
                          .where(
                            (feedback) =>
                                feedback
                                    .status !=
                                'Hoàn thành',
                          )
                          .length
                          .toString(),
                      icon:
                          Icons.inbox_outlined,
                      color:
                          AppColors.warning,
                      note:
                          'Cần tiếp tục xử lý',
                    ),

                    _StatBox(
                      title:
                          'Vi phạm mở',
                      value: repo.violations
                          .where(
                            (violation) =>
                                violation
                                    .status !=
                                'Hoàn thành',
                          )
                          .length
                          .toString(),
                      icon: Icons
                          .shield_outlined,
                      color:
                          AppColors.danger,
                      note:
                          'Cần kiểm tra',
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 22),

            LayoutBuilder(
              builder: (
                context,
                constraints,
              ) {
                final desktop =
                    constraints.maxWidth >
                        900;

                final payment =
                    _buildPaymentProgress(
                  repo,
                );

                final recent =
                    _buildRecentActivity();

                if (!desktop) {
                  return Column(
                    children: [
                      payment,
                      const SizedBox(
                        height: 18,
                      ),
                      recent,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: payment,
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: recent,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 22),

            SectionCard(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
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
                              'Công việc cần ưu tiên',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Các đầu việc cần xử lý hôm nay',
                              style: TextStyle(
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text(
                          'Mở danh sách',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  const Divider(),

                  const ListTile(
                    contentPadding:
                        EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor:
                          AppColors
                              .dangerLight,
                      child: Icon(
                        Icons.priority_high,
                        color:
                            AppColors.danger,
                      ),
                    ),
                    title: Text(
                      'Xử lý phản ánh khẩn cấp tầng 8',
                    ),
                    subtitle: Text(
                      'Cần hoàn tất trước 12:00 hôm nay',
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

  Widget _buildPaymentProgress(
    AppRepository repo,
  ) {
    final double total =
        repo.invoices.fold<double>(
      0.0,
      (
        sum,
        invoice,
      ) {
        return sum + invoice.total;
      },
    );

    final double paid =
        repo.invoices.fold<double>(
      0.0,
      (
        sum,
        invoice,
      ) {
        return sum + invoice.paid;
      },
    );

    double percent = 0.0;

    if (total > 0) {
      percent = paid / total;
    }

    if (percent > 1) {
      percent = 1;
    }

    final paidCount =
        repo.invoices
            .where(
              (invoice) =>
                  invoice.status ==
                  'Đã thanh toán',
            )
            .length;

    final partialCount =
        repo.invoices
            .where(
              (invoice) =>
                  invoice.status ==
                  'Thanh toán một phần',
            )
            .length;

    final overdueCount =
        repo.invoices
            .where(
              (invoice) =>
                  invoice.status ==
                  'Quá hạn',
            )
            .length;

    return SectionCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tiến độ thu phí tháng 10',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Theo trạng thái thanh toán hóa đơn',
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              OutlinedButton(
                onPressed: () {},
                child: const Text(
                  'Xem báo cáo',
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: Text(
                  formatMoney(paid),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${(percent * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  color:
                      AppColors.success,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            color: AppColors.success,
            backgroundColor:
                const Color(
              0xFFEEF1F5,
            ),
            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: _miniStat(
                  'Đã thanh toán',
                  '$paidCount',
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _miniStat(
                  'Một phần',
                  '$partialCount',
                  AppColors.warning,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _miniStat(
                  'Quá hạn',
                  '$overdueCount',
                  AppColors.danger,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return SectionCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Hoạt động gần đây',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child:
                    const Text(
                  'Xem tất cả',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _activity(
            Icons.person_add_alt,
            AppColors.primary,
            'Đăng ký nhân khẩu',
            'Căn A-05-01',
          ),

          _activity(
            Icons.check_circle_outline,
            AppColors.success,
            'Hóa đơn đã thanh toán',
            'Đã xác nhận giao dịch',
          ),

          _activity(
            Icons.message_outlined,
            AppColors.warning,
            'Phản ánh mới',
            'Yêu cầu từ cư dân',
          ),

          _activity(
            Icons.build_outlined,
            AppColors.success,
            'Công việc bảo trì',
            'Đã cập nhật tiến độ',
          ),
        ],
      ),
    );
  }

  Widget _activity(
    IconData icon,
    Color color,
    String title,
    String subtitle,
  ) {
    return ListTile(
      contentPadding:
          EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withValues(
            alpha: 0.08,
          ),
          borderRadius:
              BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          color: color,
          size: 21,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight:
              FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
    );
  }

  Widget _miniStat(
    String title,
    String value,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(
          0xFFF7F9FC,
        ),
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color:
                  AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox
    extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String note;

  const _StatBox({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors
                        .textSecondary,
                  ),
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration:
                    BoxDecoration(
                  color: color.withValues(
                    alpha: 0.08,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 29,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            note,
            style: TextStyle(
              color: color,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}