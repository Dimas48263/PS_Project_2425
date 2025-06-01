import 'package:flutter/material.dart';

Widget customSearchBar(TextEditingController searchController, void Function(String) onChanged) {
  return Expanded(
    child: TextField(
      controller: searchController,
      decoration: InputDecoration(
        labelText: 'Pesquisar',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onChanged: (value) => onChanged(value),
    ),
  );
}
