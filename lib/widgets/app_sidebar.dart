import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class AppNavItem {
  final String title;
  final IconData icon;

  const AppNavItem({
    required this.title,
    required this.icon,
  });
}

class AppSidebar extends StatelessWidget {
  final List<AppNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onLogout;

  const AppSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: AppColors.sidebar,
      padding: const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        18,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.apartment_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 13),
              const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'BLUEHOME',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  Text(
                    'QUẢN LÝ CHUNG CƯ',
                    style: TextStyle(
                      color: Color(0xFFA7B0C0),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 8),
              itemBuilder: (_, index) {
                final selected =
                    selectedIndex == index;

                return InkWell(
                  borderRadius:
                      BorderRadius.circular(11),
                  onTap: () {
                    onSelected(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 150,
                    ),
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(11),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          items[index].icon,
                          size: 22,
                          color: selected
                              ? Colors.white
                              : const Color(
                                  0xFF97A3B6,
                                ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            items[index].title,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : const Color(
                                      0xFFD2D8E2,
                                    ),
                              fontSize: 14,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  AppColors.sidebarSecondary,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Chung cư BlueHome',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '18 Nguyễn Cơ Thạch, Nam Từ Liêm, Hà Nội',
                  style: TextStyle(
                    color: Color(
                      0xFFA5AFC0,
                    ),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          InkWell(
            onTap: onLogout,
            borderRadius:
                BorderRadius.circular(10),
            child: const Padding(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color:
                        Color(0xFFFF8A8A),
                  ),
                  SizedBox(width: 14),
                  Text(
                    'Đăng xuất',
                    style: TextStyle(
                      color:
                          Color(0xFFFF8A8A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}