import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/formatters.dart';
import '../../data/app_repository.dart';
import '../../models/invoice.dart';
import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';

class ResidentPaymentPage
    extends StatelessWidget {
  const ResidentPaymentPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final repo =
        AppRepository.instance;

    return AnimatedBuilder(
      animation: repo,
      builder: (_, __) {
        final invoices =
            repo.invoicesForApartment(
          repo.currentResidentApartmentId,
        );

        double totalDebt = 0.0;

        for (final invoice in invoices) {
          totalDebt += invoice.debt;
        }

        return ListView(
          padding:
              const EdgeInsets.fromLTRB(
            30,
            28,
            30,
            40,
          ),
          children: [
            const Text(
              'Phí dịch vụ',
              style: TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Theo dõi và thanh toán các khoản phí của căn hộ.',
              style: TextStyle(
                color:
                    AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding:
                  const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color:
                    AppColors.primary,
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng số tiền cần thanh toán',
                    style: TextStyle(
                      color:
                          Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    formatMoney(totalDebt),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${invoices.where((e) => e.debt > 0).length} hóa đơn chưa hoàn tất',
                    style: const TextStyle(
                      color:
                          Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Danh sách hóa đơn',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            ...invoices.map(
              (invoice) {
                return Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 14,
                  ),
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                    onTap: () {
                      _showInvoiceDetail(
                        context,
                        invoice,
                      );
                    },
                    child: SectionCard(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      'Hóa đơn ${invoice.period}',
                                      style:
                                          const TextStyle(
                                        fontSize:
                                            18,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                    Text(
                                      invoice.id,
                                      style:
                                          const TextStyle(
                                        color:
                                            AppColors
                                                .textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              StatusChip(
                                invoice.status,
                              ),
                            ],
                          ),

                          const Divider(
                            height: 28,
                          ),

                          ...invoice.items.map(
                            (item) {
                              return Padding(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical: 5,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name,
                                      ),
                                    ),
                                    Text(
                                      formatMoney(
                                        item.amount,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const Divider(
                            height: 28,
                          ),

                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Tổng phải thu',
                                  style:
                                      TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                              Text(
                                formatMoney(
                                  invoice.total,
                                ),
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 7,
                          ),

                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Đã thanh toán',
                                ),
                              ),
                              Text(
                                formatMoney(
                                  invoice.paid,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 7,
                          ),

                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Còn phải trả',
                                  style:
                                      TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                              Text(
                                formatMoney(
                                  invoice.debt,
                                ),
                                style:
                                    const TextStyle(
                                  color:
                                      AppColors
                                          .primary,
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showInvoiceDetail(
    BuildContext context,
    Invoice invoice,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Hóa đơn ${invoice.period}',
          ),
          content: SizedBox(
            width: 600,
            child:
                SingleChildScrollView(
              child: Column(
                children: [
                  ...invoice.items.map(
                    (item) {
                      return ListTile(
                        contentPadding:
                            EdgeInsets.zero,
                        title: Text(
                          item.name,
                        ),
                        subtitle: Text(
                          '${item.quantity} ${item.unit} × ${formatMoney(item.unitPrice)}',
                        ),
                        trailing: Text(
                          formatMoney(
                            item.amount,
                          ),
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      );
                    },
                  ),

                  const Divider(),

                  _summaryRow(
                    'Tổng phải thu',
                    formatMoney(
                      invoice.total,
                    ),
                    true,
                  ),
                  _summaryRow(
                    'Đã thanh toán',
                    formatMoney(
                      invoice.paid,
                    ),
                    false,
                  ),
                  _summaryRow(
                    'Còn phải trả',
                    formatMoney(
                      invoice.debt,
                    ),
                    true,
                  ),
                ],
              ),
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
                  const Text('Đóng'),
            ),

            if (invoice.debt > 0)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );

                  _showPaymentForm(
                    context,
                    invoice,
                  );
                },
                child: const Text(
                  'Thanh toán ngay',
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _summaryRow(
    String title,
    String value,
    bool bold,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: bold
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentForm(
    BuildContext context,
    Invoice invoice,
  ) {
    final amountController =
        TextEditingController(
      text: invoice.debt
          .toStringAsFixed(0),
    );

    final transactionController =
        TextEditingController();

    String method =
        'Chuyển khoản';

    showDialog(
      context: context,
      builder: (
        dialogContext,
      ) {
        return StatefulBuilder(
          builder: (
            context,
            setState,
          ) {
            return AlertDialog(
              title: const Text(
                'Xác nhận thanh toán',
              ),
              content: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    TextField(
                      controller:
                          amountController,
                      keyboardType:
                          TextInputType
                              .number,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Số tiền thanh toán',
                        suffixText:
                            'VNĐ',
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    DropdownButtonFormField<
                        String>(
                      value: method,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Phương thức thanh toán',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value:
                              'Chuyển khoản',
                          child: Text(
                            'Chuyển khoản',
                          ),
                        ),
                        DropdownMenuItem(
                          value:
                              'Tiền mặt',
                          child: Text(
                            'Tiền mặt',
                          ),
                        ),
                      ],
                      onChanged: (
                        value,
                      ) {
                        if (value !=
                            null) {
                          setState(
                            () {
                              method =
                                  value;
                            },
                          );
                        }
                      },
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    TextField(
                      controller:
                          transactionController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Mã giao dịch',
                        hintText:
                            'VD: GD123456',
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
                    final amount =
                        double.tryParse(
                      amountController
                          .text
                          .trim(),
                    );

                    if (amount ==
                            null ||
                        amount <= 0 ||
                        amount >
                            invoice
                                .debt) {
                      ScaffoldMessenger
                              .of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Số tiền thanh toán không hợp lệ',
                          ),
                        ),
                      );

                      return;
                    }

                    AppRepository
                        .instance
                        .createPaymentRequest(
                      invoiceId:
                          invoice.id,
                      amount: amount,
                      method: method,
                      transactionCode:
                          transactionController
                              .text
                              .trim(),
                    );

                    Navigator.pop(
                      dialogContext,
                    );

                    ScaffoldMessenger
                            .of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Đã gửi yêu cầu thanh toán. Chờ Ban quản lý xác nhận.',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Gửi thanh toán',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}