import 'package:saveup/core/constants/app_constants.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static String formatVnd(num amount) {
    final isNegative = amount < 0;
    final digits = amount.abs().round().toString();
    final buffer = StringBuffer();
    final reversedDigits = digits.split('').reversed.toList();

    for (var index = 0; index < reversedDigits.length; index++) {
      if (index > 0 && index % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(reversedDigits[index]);
    }

    final formattedNumber = buffer.toString().split('').reversed.join();
    final prefix = isNegative ? '-' : '';

    return '$prefix$formattedNumber${AppConstants.currencySymbol}';
  }
}
