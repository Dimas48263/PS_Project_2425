import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zcap_net_app/widgets/custom_search_bar.dart';

class CustomSearchAndAddBar extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String) onSearchChanged;
  final VoidCallback onIconPressed;
  final Widget? dropDownFilter;
  final IconData trailingIcon;
  final bool canWrite;

  const CustomSearchAndAddBar({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    required this.onIconPressed,
    this.dropDownFilter,
    this.trailingIcon = Icons.add,
    this.canWrite = true
  });
  @override
  State<CustomSearchAndAddBar> createState() => _CustomSearchAndAddBarState();
}

class _CustomSearchAndAddBarState extends State<CustomSearchAndAddBar> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 250), () {
      widget.onSearchChanged(widget.controller.text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: customSearchBar(widget.controller, (_){}),
        ),
        if (widget.dropDownFilter != null)
          SizedBox(
            width: 150, 
            child: widget.dropDownFilter!,
          ),
        const SizedBox(width: 8.0),
        if (widget.canWrite) ElevatedButton(
          onPressed: widget.onIconPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            minimumSize: const Size(60.0, 60.0),
          ),
          child: Icon(widget.trailingIcon, size: 40.0,),
        ),
      ],
    );
  }
}
