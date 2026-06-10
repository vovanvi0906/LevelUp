import 'package:flutter/material.dart';
import 'package:saveup/core/constants/app_constants.dart';
import 'package:saveup/core/theme/app_colors.dart';

class LevelUpLogo extends StatelessWidget {
  final double logoSize;
  final double fontSize;
  final double spacing;

  const LevelUpLogo({
    super.key,
    this.logoSize = 56,
    this.fontSize = 38,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(logoSize * 0.32),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            color: AppColors.white,
            size: logoSize * 0.58,
          ),
        ),
        SizedBox(width: spacing),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              AppConstants.appName,
              style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
