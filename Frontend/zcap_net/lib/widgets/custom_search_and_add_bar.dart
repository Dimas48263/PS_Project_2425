import 'package:flutter/material.dart';
import 'package:zcap_net_app/widgets/custom_search_bar.dart';

class CustomSearchAndAddBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSearchChanged;
  final VoidCallback onAddPressed;
  final Widget? dropDownFilter;

  const CustomSearchAndAddBar({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    required this.onAddPressed,
    this.dropDownFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: customSearchBar(controller, onSearchChanged),
        ),
        if (dropDownFilter != null)
          SizedBox(
            width: 150, 
            child: dropDownFilter!,
          ),
        const SizedBox(width: 8.0),
        ElevatedButton(
          onPressed: onAddPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            minimumSize: const Size(50.0, 50.0),
          ),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
