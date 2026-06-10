import 'package:flutter/material.dart';
import 'package:saveup/models/category_model.dart';
import 'package:saveup/models/transaction_model.dart';
import 'package:saveup/models/wallet_model.dart';
import 'package:saveup/screens/transaction/select_category_screen.dart';
import 'package:saveup/screens/transaction/select_wallet_screen.dart';
import 'package:saveup/screens/transaction/widgets/transaction_selector_card.dart';
import 'package:saveup/screens/transaction/widgets/transaction_type_selector.dart';
import 'package:saveup/state/app_state.dart';
import 'package:saveup/widgets/app_button.dart';
import 'package:saveup/widgets/app_text_field.dart';

class TransactionForm extends StatefulWidget {
  final AppState appState;
  final TransactionModel? initialTransaction;
  final String submitLabel;
  final void Function(TransactionModel transaction) onSubmit;

  const TransactionForm({
    super.key,
    required this.appState,
    required this.submitLabel,
    required this.onSubmit,
    this.initialTransaction,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  late TransactionType _transactionType;
  late DateTime _selectedDate;
  CategoryModel? _selectedCategory;
  WalletModel? _selectedWallet;
  var _submitted = false;

  @override
  void initState() {
    super.initState();
    final transaction = widget.initialTransaction;
    _transactionType = transaction?.type ?? TransactionType.expense;
    _selectedDate = transaction?.dateTime ?? DateTime.now();
    _selectedCategory = transaction == null
        ? null
        : widget.appState.findCategoryById(transaction.categoryId);
    _selectedWallet = transaction == null
        ? null
        : widget.appState.findWalletById(transaction.walletId);
    _titleController.text = transaction?.title ?? '';
    _amountController.text = transaction == null
        ? ''
        : transaction.amount.round().toString();
    _noteController.text = transaction?.note ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TransactionTypeSelector(
            selectedType: _transactionType,
            onChanged: (type) {
              setState(() {
                _transactionType = type;
                if (_selectedCategory?.type != type) {
                  _selectedCategory = null;
                }
              });
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _amountController,
            label: 'Số tiền',
            hintText: 'Ví dụ: 45000',
            prefixIcon: Icons.payments_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: _validateAmount,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _titleController,
            label: 'Tên giao dịch',
            hintText: 'Ví dụ: Cơm trưa',
            prefixIcon: Icons.edit_note_rounded,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Tên giao dịch không được để trống';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TransactionSelectorCard(
            label: 'Danh mục',
            value: _selectedCategory?.name,
            icon: Icons.category_outlined,
            errorText: _submitted && _selectedCategory == null
                ? 'Phải chọn danh mục'
                : null,
            onTap: _pickCategory,
          ),
          const SizedBox(height: 16),
          TransactionSelectorCard(
            label: 'Ví sử dụng',
            value: _selectedWallet?.name,
            icon: Icons.account_balance_wallet_outlined,
            errorText: _submitted && _selectedWallet == null
                ? 'Phải chọn ví'
                : null,
            onTap: _pickWallet,
          ),
          const SizedBox(height: 16),
          TransactionSelectorCard(
            label: 'Ngày giao dịch',
            value: _formatDate(_selectedDate),
            icon: Icons.calendar_month_outlined,
            onTap: _pickDate,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _noteController,
            label: 'Ghi chú',
            hintText: 'Nhập ghi chú nếu có',
            prefixIcon: Icons.notes_rounded,
            maxLines: 3,
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

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Số tiền không được để trống';
    }

    final amount = _parseAmount(value);
    if (amount == null || amount <= 0) {
      return 'Số tiền phải lớn hơn 0';
    }

    return null;
  }

  Future<void> _pickCategory() async {
    final category = await Navigator.push<CategoryModel>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectCategoryScreen(
          appState: widget.appState,
          transactionType: _transactionType,
        ),
      ),
    );

    if (category == null || !mounted) {
      return;
    }

    setState(() {
      _selectedCategory = category;
    });
  }

  Future<void> _pickWallet() async {
    final wallet = await Navigator.push<WalletModel>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectWalletScreen(appState: widget.appState),
      ),
    );

    if (wallet == null || !mounted) {
      return;
    }

    setState(() {
      _selectedWallet = wallet;
    });
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submit() {
    setState(() {
      _submitted = true;
    });

    if (!_formKey.currentState!.validate() ||
        _selectedCategory == null ||
        _selectedWallet == null) {
      return;
    }

    final amount = _parseAmount(_amountController.text)!;
    final now = DateTime.now();
    final transaction = TransactionModel(
      id:
          widget.initialTransaction?.id ??
          'transaction_${now.millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      amount: amount,
      type: _transactionType,
      categoryId: _selectedCategory!.id,
      walletId: _selectedWallet!.id,
      note: _noteController.text.trim(),
      dateTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        now.hour,
        now.minute,
      ),
    );

    widget.onSubmit(transaction);
  }

  double? _parseAmount(String value) {
    final normalizedValue = value
        .trim()
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(normalizedValue);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
