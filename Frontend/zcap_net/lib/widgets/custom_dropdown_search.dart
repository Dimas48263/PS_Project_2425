import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget customDropdownSearch<T>(
    {required List<T> items,
    required T? selectedItem,
    required void Function(T?) onSelected,
    required String? Function(T?) validator,
    String? label,
    bool justLabel = false,
    final String Function(T)? itemLabelBuilder,
    bool enabled = true}) {
  return DropdownSearch<T>(
    enabled: enabled,
    items: items,
    selectedItem: selectedItem,
    popupProps: PopupProps.menu(
      showSearchBox: true,
      searchFieldProps: TextFieldProps(
        decoration: InputDecoration(
          labelText: 'search'.tr(),
        ),
      ),
    ),
    itemAsString: itemLabelBuilder ?? (item) => item.toString(),
    onChanged: (value) => onSelected(value),
    validator: (value) => validator(value),
    dropdownDecoratorProps: DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
        labelText: label == null ? 'select_an_option'.tr() : justLabel ? label : 'select_label'.tr(namedArgs: {'label': label}),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    ),
  );
}
