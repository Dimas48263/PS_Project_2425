import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zcap_net_app/features/settings/models/text_controllers_input_form.dart';

final dateFormat = DateFormat('yyyy-MM-dd');

Widget buildForm(
    List<TextEditingController> textControllers,
    List<String> labels,
    DateTime? startDate,
    DateTime? endDate,
    Function onStartDateChanged,
    Function onEndDateChanged) {
  return Form(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
    for (int i = 0; i < textControllers.length; i++)
      TextFormField(
          controller: textControllers[i],
          decoration: InputDecoration(labelText: labels[i]),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira um ${labels[i]}';
            }
            return null;
          }),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Row(
              children: [
                Text(
                  'Data Inicio:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                Text(
                  " ${startDate != null ? dateFormat.format(startDate) : 'yyyy-MM-dd'}",
                  style: TextStyle(fontSize: 20.0),
                ),
                TextButton(
                  onPressed: () => onStartDateChanged(),
                  child: Icon(Icons.calendar_month),
                ),
              ],
            )),
            VerticalDivider(thickness: 10.0),
            Expanded(
                child: Row(
              children: [
                Text(
                  'Data Fim:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                Text(
                  " ${endDate != null ? dateFormat.format(endDate) : 'yyyy-MM-dd'}",
                  style: TextStyle(fontSize: 20.0),
                ),
                TextButton(
                  onPressed: () => onEndDateChanged(),
                  child: Icon(Icons.calendar_month),
                ),
              ],
            )),
          ],
        ),
      ),
    ),
  ]));
}

/** START SECOND VERSION */
Widget customDatesForm(BuildContext context, DateTime? date,
    void Function(DateTime) onDateChanged, bool isStartDate, void Function()? onLongPress) {
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

Widget buildForm2(
    BuildContext context,
    List<TextControllersInputFormConfig> textControllersConfig,
    DateTime? startDate,
    DateTime? endDate,
    void Function(DateTime) onStartDateChanged,
    void Function(DateTime) onEndDateChanged,
    void Function()? onLongPress,
    List<Widget> dropDownSearches) {
  return Form(
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
    customDatesForm(context, startDate, (date) => onStartDateChanged(date), true, null),
    customDatesForm(context, endDate, (date) => onEndDateChanged(date), false, onLongPress),
  ]));
}
