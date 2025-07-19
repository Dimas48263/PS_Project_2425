import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/widgets/text_controllers_input_form.dart';

final dateFormat = DateFormat('yyyy-MM-dd');

Widget customDatesForm(
    BuildContext context,
    DateTime? date,
    void Function(DateTime) onDateChanged,
    bool isStartDate,
    void Function()? onLongPress,
    bool canWrite) {
  String title = isStartDate ? 'start'.tr() : 'end'.tr();
  return ListTile(
    title: Text(
        "$title: ${date != null ? date.toLocal().toString().split(' ')[0] : 'no_end_date'.tr()}"),
    trailing: const Icon(Icons.calendar_today),
    onTap: () async {
      if (!canWrite) return;
      final picked = await showDatePicker(
        context: context,
        initialDate: date ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        onDateChanged(picked);
      }
    },
    onLongPress: () {
      if (!canWrite) return;
      if (onLongPress != null) {
        onLongPress();
      }
    },
  );
}

Widget buildForm(
    GlobalKey<FormState> formKey,
    BuildContext context,
    List<TextControllersInputFormConfig> textControllersConfig,
    DateTime? startDate,
    DateTime? endDate,
    void Function(DateTime) onStartDateChanged,
    void Function(DateTime) onEndDateChanged,
    void Function()? onLongPress,
    List<Widget> dropDownSearches,
    {bool canWrite = true}) {
  return Form(
      key: formKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        for (var config in textControllersConfig)
          TextFormField(
              enabled: canWrite,
              controller: config.controller,
              decoration: InputDecoration(labelText: config.label),
              validator: (value) {
                if (config.validator != null) {
                  return config.validator!(value);
                }
                if (value == null || value.isEmpty) {
                  return 'fill_data'.tr(namedArgs: {
                    'field': config.label,
                  });
                }
                return null;
              }),
        ...dropDownSearches,
        customDatesForm(
            context, startDate, (date) => onStartDateChanged(date), true, null, canWrite),
        customDatesForm(context, endDate, (date) => onEndDateChanged(date),
            false, onLongPress, canWrite),
      ]));
}

class DateInputConfig {
  String label;
  DateTime? date;
  void Function(DateTime?) onDateChanged;
  void Function()? onLongPress;
  String? Function(DateTime?)? validator;
  DateInputConfig(
      {required this.label,
      required this.date,
      required this.onDateChanged,
      this.onLongPress,
      this.validator});
}

Widget customDatesFormField({
  required BuildContext context,
  required DateTime? date,
  required bool isStartDate,
  required String label,
  required void Function(DateTime?) onDateChanged,
  String? Function(DateTime?)? validator,
  void Function()? onLongPress,
  bool canWrite = true
}) {
  return FormField<DateTime>(
    initialValue: date,
    validator: validator,
    onSaved: onDateChanged,
    builder: (FormFieldState<DateTime> state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onLongPress: () {
              if (!canWrite) return;
              if (onLongPress != null) {
                state.didChange(null);
                onDateChanged(null);
                onLongPress();
              }
            },
            onTap: () async {
              if (!canWrite) return;
              final picked = await showDatePicker(
                context: context,
                initialDate: state.value ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                state.didChange(picked);
                onDateChanged(picked);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "$label: ${state.value != null ? state.value!.toLocal().toString().split(' ')[0] : 'no_date'.tr()}",
                    ),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                state.errorText!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      );
    },
  );
}

Widget buildFormWithoutDates(
    GlobalKey<FormState> formKey,
    BuildContext context,
    List<TextControllersInputFormConfig> textControllersConfig,
    List<Widget> dropDownSearches,
    List<DateInputConfig> dates,
    {bool canWrite = true}) {
  return Form(
      key: formKey,
      child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        for (var config in textControllersConfig)
          TextFormField(  
              enabled: canWrite,
              controller: config.controller,
              decoration: InputDecoration(labelText: config.label),
              validator: (value) {
                if (config.validator != null) {
                  return config.validator!(value);
                }
                if (value == null || value.isEmpty) {
                  return 'fill_data'.tr(namedArgs: {
                    'field': config.label,
                  });
                }
                return null;
              }),
        ...dropDownSearches,
        for (var date in dates)
          customDatesFormField(
              context: context,
              date: date.date,
              label: date.label,
              isStartDate: true,
              onDateChanged: date.onDateChanged,
              validator: date.validator,
              onLongPress: date.onLongPress,
              canWrite: canWrite),
      ])));
}
