import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xin chào!',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Hôm nay bạn muốn quản lý tài chính thế nào?',
                style: TextStyle(
                  color: AppColors.textGray,
                  fontSize: 15,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.primaryGreen,
            size: 30,
          ),
        ),
      ],
    );
  }
}
