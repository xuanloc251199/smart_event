import 'package:flutter/material.dart';

class NavBarItem {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final String? iconSize;

  NavBarItem({
    required this.icon,
    required this.imagePath,
    required this.label,
    required this.iconSize,
  });
}
