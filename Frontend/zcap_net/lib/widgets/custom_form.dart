import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zcap_net_app/features/settings/models/text_controllers_input_form.dart';

final dateFormat = DateFormat('yyyy-MM-dd');

Widget customDatesForm(
    BuildContext context,
    DateTime? date,
    void Function(DateTime) onDateChanged,
    bool isStartDate,
    void Function()? onLongPress) {
  String title = isStartDate ? "Início" : "Fim";
  return ListTile(
    title: Text(
        "$title: ${date != null ? date.toLocal().toString().split(' ')[0] : 'Sem data'}"),
    trailing: const Icon(Icons.calendar_today),
    onTap: () async {
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
    List<Widget> dropDownSearches) {
  return Form(
      key: formKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        for (var config in textControllersConfig)
          TextFormField(
              controller: config.controller,
              decoration: InputDecoration(labelText: config.label),
              validator: (value) {
                if (config.validator != null) {
                  return config.validator!(value);
                }
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um ${config.label}';
                }
                return null;
              }),
        ...dropDownSearches,
        customDatesForm(
            context, startDate, (date) => onStartDateChanged(date), true, null),
        customDatesForm(context, endDate, (date) => onEndDateChanged(date),
            false, onLongPress),
      ]));
}
