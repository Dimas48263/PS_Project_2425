import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import '../shared/date_utils.dart';

class CustomDateRangePicker extends StatelessWidget {
  final DateTime startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final DateUtilsService dateUtilsService;

  const CustomDateRangePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    this.dateUtilsService = const DateUtilsService(),
  });

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(1977),
      lastDate: DateTime(2666),
    );
    if (picked != null) {
      final isValid = dateUtilsService.validateStartEndDate(
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
      final isValid = dateUtilsService.validateStartEndDate(
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
          title: Text(
              '${"start".tr()}: ${startDate.toLocal().toString().split(' ')[0]}'),
          trailing: const Icon(Icons.calendar_today),
          onTap: () => _selectStartDate(context),
        ),
        ListTile(
          title: Text(
              '${"end".tr()}: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : 'no_end_date'.tr()}'),
          trailing: const Icon(Icons.calendar_today),
          onTap: () => _selectEndDate(context),
          onLongPress: () => onEndDateChanged(null),
        ),
      ],
    );
  }
}
