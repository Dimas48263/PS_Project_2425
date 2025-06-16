import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget customSearchBar(TextEditingController searchController, void Function(String) onChanged) {
  return TextField(
    controller: searchController,
    decoration: InputDecoration(
      labelText: 'search'.tr(),
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    onChanged: (value) => onChanged(value),
  );
}
