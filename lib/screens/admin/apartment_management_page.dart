import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/app_repository.dart';
import '../../models/apartment.dart';
import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';

class ApartmentManagementPage extends StatefulWidget {
  const ApartmentManagementPage({super.key});

  @override
  State<ApartmentManagementPage> createState() =>
      _ApartmentManagementPageState();
}

class _ApartmentManagementPageState extends State<ApartmentManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedBuilding = 'Tất cả';
  String _selectedStatus = 'Tất cả';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddApartmentDialog(BuildContext context) {
    final buildingController = TextEditingController(text: 'A');
    final floorController = TextEditingController();
    final unitController = TextEditingController();
    final ownerController = TextEditingController();
    final memberController = TextEditingController(text: '0');
    bool isVacant = true;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Thêm căn hộ mới'),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: buildingController.text,
                        decoration: const InputDecoration(labelText: 'Tòa nhà'),
                        items: const [
                          DropdownMenuItem(value: 'A', child: Text('Tòa A')),
                          DropdownMenuItem(value: 'B', child: Text('Tòa B')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              buildingController.text = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: floorController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tầng',
                          hintText: 'Ví dụ: 5',
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: unitController,
                        decoration: const InputDecoration(
                          labelText: 'Số phòng / Mã căn',
                          hintText: 'Ví dụ: 01 hoặc 02',
                        ),
                      ),
                      const SizedBox(height: 14),
                      CheckboxListTile(
                        title: const Text('Căn hộ còn trống'),
                        value: isVacant,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) {
                          setDialogState(() {
                            isVacant = val ?? true;
                          });
                        },
                      ),
                      if (!isVacant) ...[
                        const SizedBox(height: 10),
                        TextField(
                          controller: ownerController,
                          decoration: const InputDecoration(
                            labelText: 'Tên chủ hộ',
                            hintText: 'Nhập họ và tên chủ hộ',
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: memberController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Số nhân khẩu',
                            hintText: 'Ví dụ: 3',
                          ),
                        ),
                      ],
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
                    final building = buildingController.text.trim();
                    final floor = int.tryParse(floorController.text.trim()) ?? 1;
                    final unit = unitController.text.trim();

                    if (unit.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vui lòng nhập số phòng / mã căn'),
                        ),
                      );
                      return;
                    }

                    final padFloor = floor.toString().padLeft(2, '0');
                    final newId = '$building-$padFloor-$unit';
                    final memberCount =
                        int.tryParse(memberController.text.trim()) ?? 0;

                    final newApt = Apartment(
                      id: newId,
                      building: building,
                      floor: floor,
                      unit: unit,
                      ownerName: isVacant ? null : ownerController.text.trim(),
                      memberCount: isVacant ? 0 : memberCount,
                      isVacant: isVacant,
                    );

                    AppRepository.instance.addApartment(newApt);
                    Navigator.pop(dialogCtx);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã thêm căn hộ ${newApt.displayCode}'),
                      ),
                    );
                  },
                  child: const Text('Thêm căn hộ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditApartmentDialog(BuildContext context, Apartment apt) {
    final ownerController = TextEditingController(text: apt.ownerName ?? '');
    final memberController =
        TextEditingController(text: apt.memberCount.toString());
    bool isVacant = apt.isVacant;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Chỉnh sửa căn hộ ${apt.displayCode}'),
              content: SizedBox(
                width: 460,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      title: const Text('Căn hộ còn trống'),
                      value: isVacant,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setDialogState(() {
                          isVacant = val ?? true;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ownerController,
                      enabled: !isVacant,
                      decoration: const InputDecoration(
                        labelText: 'Tên chủ hộ',
                        hintText: 'Nhập họ và tên chủ hộ',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: memberController,
                      enabled: !isVacant,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Số nhân khẩu',
                        hintText: 'Số lượng người đang ở',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final updated = Apartment(
                      id: apt.id,
                      building: apt.building,
                      floor: apt.floor,
                      unit: apt.unit,
                      isVacant: isVacant,
                      ownerName: isVacant ? null : ownerController.text.trim(),
                      memberCount: isVacant
                          ? 0
                          : (int.tryParse(memberController.text.trim()) ?? 0),
                    );

                    AppRepository.instance.updateApartment(updated);
                    Navigator.pop(dialogCtx);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Đã cập nhật căn hộ ${apt.displayCode}'),
                      ),
                    );
                  },
                  child: const Text('Lưu thay đổi'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteApartmentDialog(BuildContext context, Apartment apt) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa căn hộ ${apt.displayCode} khỏi hệ thống?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
              ),
              onPressed: () {
                AppRepository.instance.deleteApartment(apt.id);
                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã xóa căn hộ ${apt.displayCode}'),
                  ),
                );
              },
              child: const Text('Xóa'),
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
        final query = _searchController.text.trim().toLowerCase();

        final filtered = repo.apartments.where((apt) {
          final matchesQuery = query.isEmpty ||
              apt.displayCode.toLowerCase().contains(query) ||
              apt.id.toLowerCase().contains(query) ||
              (apt.ownerName?.toLowerCase().contains(query) ?? false);

          final matchesBuilding = _selectedBuilding == 'Tất cả' ||
              apt.building == _selectedBuilding.replaceAll('Tòa ', '');

          final matchesStatus = _selectedStatus == 'Tất cả' ||
              (_selectedStatus == 'Đang ở' && !apt.isVacant) ||
              (_selectedStatus == 'Còn trống' && apt.isVacant);

          return matchesQuery && matchesBuilding && matchesStatus;
        }).toList();

        final totalApts = repo.apartments.length;
        final occupiedApts =
            repo.apartments.where((a) => !a.isVacant).length;
        final vacantApts =
            repo.apartments.where((a) => a.isVacant).length;
        final totalResidents = repo.totalMembers;

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
                        'Quản lý căn hộ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Danh sách toàn bộ căn hộ, chủ sở hữu và nhân khẩu.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddApartmentDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm căn hộ'),
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
                      'Tổng căn hộ',
                      '$totalApts',
                      Icons.apartment_outlined,
                      AppColors.primary,
                    ),
                    _statCard(
                      'Đang ở',
                      '$occupiedApts',
                      Icons.people_outline,
                      AppColors.success,
                    ),
                    _statCard(
                      'Còn trống',
                      '$vacantApts',
                      Icons.meeting_room_outlined,
                      AppColors.warning,
                    ),
                    _statCard(
                      'Tổng cư dân',
                      '$totalResidents',
                      Icons.groups_outlined,
                      AppColors.primaryDark,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 22),

            // Filter bar
            SectionCard(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 280,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Tìm theo mã căn hoặc tên...',
                        prefixIcon: Icon(Icons.search, size: 20),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedBuilding,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Tất cả',
                        child: Text('Tất cả tòa'),
                      ),
                      DropdownMenuItem(
                        value: 'Tòa A',
                        child: Text('Tòa A'),
                      ),
                      DropdownMenuItem(
                        value: 'Tòa B',
                        child: Text('Tòa B'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedBuilding = val;
                        });
                      }
                    },
                  ),
                  DropdownButton<String>(
                    value: _selectedStatus,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Tất cả',
                        child: Text('Tất cả trạng thái'),
                      ),
                      DropdownMenuItem(
                        value: 'Đang ở',
                        child: Text('Đang ở'),
                      ),
                      DropdownMenuItem(
                        value: 'Còn trống',
                        child: Text('Còn trống'),
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

            const SizedBox(height: 18),

            // Apartment List Table
            SectionCard(
              padding: EdgeInsets.zero,
              child: filtered.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'Không tìm thấy căn hộ nào phù hợp',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Mã căn')),
                          DataColumn(label: Text('Vị trí')),
                          DataColumn(label: Text('Chủ hộ')),
                          DataColumn(label: Text('Nhân khẩu')),
                          DataColumn(label: Text('Trạng thái')),
                          DataColumn(label: Text('Thao tác')),
                        ],
                        rows: filtered.map((apt) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.apartment,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      apt.displayCode,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(Text(apt.location)),
                              DataCell(
                                Text(
                                  apt.ownerName ?? 'Chưa xác định',
                                  style: TextStyle(
                                    color: apt.ownerName == null
                                        ? AppColors.textSecondary
                                        : AppColors.textPrimary,
                                    fontStyle: apt.ownerName == null
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  apt.isVacant
                                      ? '-'
                                      : '${apt.memberCount} người',
                                ),
                              ),
                              DataCell(
                                StatusChip(
                                  apt.isVacant ? 'Còn trống' : 'Đang hoạt động',
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                      ),
                                      tooltip: 'Chỉnh sửa',
                                      onPressed: () =>
                                          _showEditApartmentDialog(
                                              context, apt),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                        color: AppColors.danger,
                                      ),
                                      tooltip: 'Xóa căn hộ',
                                      onPressed: () =>
                                          _showDeleteApartmentDialog(
                                              context, apt),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
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