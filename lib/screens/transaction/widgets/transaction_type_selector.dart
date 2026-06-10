import 'package:flutter/material.dart';
import 'package:saveup/models/transaction_model.dart';

class TransactionTypeSelector extends StatelessWidget {
  final TransactionType selectedType;
  final ValueChanged<TransactionType> onChanged;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TransactionType>(
      segments: const [
        ButtonSegment(
          value: TransactionType.expense,
          label: Text('Chi'),
          icon: Icon(Icons.arrow_upward_rounded),
        ),
        ButtonSegment(
          value: TransactionType.income,
          label: Text('Thu'),
          icon: Icon(Icons.arrow_downward_rounded),
        ),
      ],
      selected: {selectedType},
      onSelectionChanged: (selection) {
        onChanged(selection.first);
      },
    );
  }
}
