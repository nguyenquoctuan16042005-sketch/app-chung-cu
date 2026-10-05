import 'package:flutter/material.dart';

import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';

class ResidentFeedbackPage
    extends StatelessWidget {
  const ResidentFeedbackPage({
    super.key,
  });

  void showForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title:
              const Text('Gửi phản ánh'),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Tiêu đề',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem(
                      value: 'Kỹ thuật',
                      child: Text('Kỹ thuật'),
                    ),
                    DropdownMenuItem(
                      value: 'An ninh',
                      child: Text('An ninh'),
                    ),
                    DropdownMenuItem(
                      value: 'Vệ sinh',
                      child: Text('Vệ sinh'),
                    ),
                  ],
                  onChanged: (_) {},
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Loại phản ánh',
                  ),
                ),
                const SizedBox(height: 12),
                const TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Nội dung',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text(
                'Gửi phản ánh',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(26),
      children: [
        Align(
          alignment:
              Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () {
              showForm(context);
            },
            icon: const Icon(Icons.add),
            label:
                const Text('Gửi phản ánh'),
          ),
        ),

        const SizedBox(height: 18),

        const SectionCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Đèn hành lang bị hỏng',
            ),
            subtitle: Text(
              '10/09/2026 • Kỹ thuật',
            ),
            trailing:
                StatusChip('Đang xử lý'),
          ),
        ),
      ],
    );
  }
}