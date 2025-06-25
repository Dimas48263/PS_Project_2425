import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/shared/shared.dart';

class CustomLocationInputField extends StatefulWidget {
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;

  const CustomLocationInputField({
    super.key,
    required this.latitudeController,
    required this.longitudeController,
  });

  @override
  State<CustomLocationInputField> createState() => _CustomLocationInputFieldState();
}

class _CustomLocationInputFieldState extends State<CustomLocationInputField> {

  @override
  void initState() {
    super.initState();
    widget.latitudeController.addListener(_onTextChanged);
    widget.longitudeController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.latitudeController.removeListener(_onTextChanged);
    widget.longitudeController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.latitudeController,
                decoration: InputDecoration(labelText: 'latitude'.tr()),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final val = double.tryParse(value);
                  if (val == null || val < -90 || val > 90) {
                    return 'invalid_latitude'.tr();
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: widget.longitudeController,
                decoration: InputDecoration(labelText: 'longitude'.tr()),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final val = double.tryParse(value);
                  if (val == null || val < -180 || val > 180) {
                    return 'invalid_longitude'.tr();
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            CustomGMapsLocationButton(
              latitude: widget.latitudeController.text,
              longitude: widget.longitudeController.text,
            ),
          ],
        ),
      ],
    );
  }
}
