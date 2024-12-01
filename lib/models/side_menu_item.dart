import 'dart:ui';

class SideMenuItem {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const SideMenuItem({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });
}
