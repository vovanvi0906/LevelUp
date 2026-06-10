import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';

class PageDot extends StatelessWidget {
  final bool active;

  const PageDot({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: active ? 22 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? AppColors.primaryBlue : AppColors.dotInactive,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
