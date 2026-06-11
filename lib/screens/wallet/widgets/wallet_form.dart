import 'package:flutter/material.dart';
import 'package:saveup/core/theme/app_colors.dart';
import 'package:saveup/core/utils/model_display.dart';
import 'package:saveup/models/wallet_model.dart';
import 'package:saveup/widgets/app_button.dart';
import 'package:saveup/widgets/app_text_field.dart';

const _walletIconNames = [
  'wallet',
  'account_balance',
  'payment',
  'savings',
  'credit_card',
];

const _walletColorValues = [
  0xFF26B83F,
  0xFF1267E8,
  0xFFE93655,
  0xFF8B5CF6,
  0xFFF59E0B,
  0xFF14B8A6,
  0xFF64748B,
];

class WalletForm extends StatefulWidget {
  final WalletModel? initialWallet;
  final String submitLabel;
  final ValueChanged<WalletModel> onSubmit;

  const WalletForm({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
    this.initialWallet,
  });

  @override
  State<WalletForm> createState() => _WalletFormState();
}

class _WalletFormState extends State<WalletForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  late WalletType _walletType;
  late String _iconName;
  late int _colorValue;

  @override
  void initState() {
    super.initState();
    final wallet = widget.initialWallet;
    _nameController.text = wallet?.name ?? '';
    _balanceController.text = wallet == null
        ? ''
        : wallet.balance.round().toString();
    _walletType = wallet?.type ?? WalletType.cash;
    _iconName = wallet?.iconName ?? 'wallet';
    _colorValue = wallet?.colorValue ?? _walletColorValues.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _nameController,
            label: 'Tên ví',
            hintText: 'Ví dụ: Tiền mặt',
            prefixIcon: Icons.account_balance_wallet_outlined,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Tên ví không được để trống';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<WalletType>(
            initialValue: _walletType,
            isExpanded: true,
            decoration: _inputDecoration(
              label: 'Loại ví',
              icon: Icons.category_outlined,
            ),
            items: WalletType.values
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(ModelDisplay.walletTypeLabel(type)),
                  ),
                )
                .toList(),
            onChanged: (type) {
              if (type == null) {
                return;
              }
              setState(() {
                _walletType = type;
              });
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _balanceController,
            label: 'Số dư ban đầu',
            hintText: 'Ví dụ: 2000000',
            prefixIcon: Icons.payments_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            validator: _validateBalance,
          ),
          const SizedBox(height: 18),
          _IconPicker(
            selectedIconName: _iconName,
            selectedColorValue: _colorValue,
            onChanged: (iconName) {
              setState(() {
                _iconName = iconName;
              });
            },
          ),
          const SizedBox(height: 18),
          _ColorPicker(
            selectedColorValue: _colorValue,
            onChanged: (colorValue) {
              setState(() {
                _colorValue = colorValue;
              });
            },
          ),
          const SizedBox(height: 24),
          AppButton(
            label: widget.submitLabel,
            icon: Icons.check_rounded,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFE1E7F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFE1E7F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.4),
      ),
    );
  }

  String? _validateBalance(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Số dư ban đầu không được để trống';
    }

    final balance = _parseAmount(value);
    if (balance == null) {
      return 'Số dư ban đầu không hợp lệ';
    }

    if (balance < 0) {
      return 'Số dư ban đầu không được âm';
    }

    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();
    final wallet = WalletModel(
      id: widget.initialWallet?.id ?? 'wallet_${now.millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      balance: _parseAmount(_balanceController.text)!,
      type: _walletType,
      iconName: _iconName,
      colorValue: _colorValue,
    );

    widget.onSubmit(wallet);
  }

  double? _parseAmount(String value) {
    final normalizedValue = value
        .trim()
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(normalizedValue);
  }
}

class _IconPicker extends StatelessWidget {
  final String selectedIconName;
  final int selectedColorValue;
  final ValueChanged<String> onChanged;

  const _IconPicker({
    required this.selectedIconName,
    required this.selectedColorValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = Color(selectedColorValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Icon ví',
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _walletIconNames.map((iconName) {
            final isSelected = selectedIconName == iconName;
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onChanged(iconName),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor.withValues(alpha: 0.14)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? selectedColor : const Color(0xFFE1E7F0),
                    width: isSelected ? 1.6 : 1,
                  ),
                ),
                child: Icon(
                  ModelDisplay.walletIcon(iconName),
                  color: isSelected ? selectedColor : AppColors.textGray,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final int selectedColorValue;
  final ValueChanged<int> onChanged;

  const _ColorPicker({
    required this.selectedColorValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Màu ví',
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _walletColorValues.map((colorValue) {
            final color = Color(colorValue);
            final isSelected = selectedColorValue == colorValue;
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onChanged(colorValue),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? AppColors.darkBlue : color,
                    width: isSelected ? 2.4 : 1,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                        size: 22,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
