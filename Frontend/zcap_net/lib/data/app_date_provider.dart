import 'package:flutter/material.dart';

class AppReferenceDateProvider extends ChangeNotifier {
  DateTime _referenceDate = DateTime.now();

  DateTime get referenceDate => _referenceDate;

  void setReferenceDate(DateTime newDate) {
    _referenceDate = newDate;
    notifyListeners();
  }
}