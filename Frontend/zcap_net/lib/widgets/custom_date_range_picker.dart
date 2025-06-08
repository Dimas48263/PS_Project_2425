import 'package:flutter/material.dart';
import '../shared/date_utils.dart';

class CustomDateRangePicker extends StatelessWidget {
  final DateTime startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;

  const CustomDateRangePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(1977),
      lastDate: DateTime(2666),
    );
    if (picked != null) {
      final isValid = DateUtilsService.validateStartEndDate(
        startDate: picked,
        endDate: endDate,
        context: context,
      );

      if (isValid) {
        onStartDateChanged(picked);
      }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(1977),
      lastDate: DateTime(2666),
    );
    if (picked != null) {
      final isValid = DateUtilsService.validateStartEndDate(
        startDate: startDate,
        endDate: picked,
        context: context,
      );
      if (isValid) {
        onEndDateChanged(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title:
              Text("Início: ${startDate.toLocal().toString().split(' ')[0]}"),
          trailing: const Icon(Icons.calendar_today),
          onTap: () => _selectStartDate(context),
        ),
        ListTile(
          title: Text(
              "Fim: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : 'Sem data'}"),
          trailing: const Icon(Icons.calendar_today),
          onTap: () => _selectEndDate(context),
          onLongPress: () => onEndDateChanged(null),
        ),
      ],
    );
  }
}
