import 'package:flutter/material.dart';

class AppReferenceDateProvider extends ChangeNotifier {
  DateTime _referenceDate = DateTime.now();

  DateTime get referenceDate => _referenceDate;

  DateTime get startOfMonth =>
      DateTime(_referenceDate.year, _referenceDate.month, 1);

  DateTime get endOfMonth =>
      DateTime(_referenceDate.year, _referenceDate.month + 1, 0);

  void setReferenceMonthYear(int year, int month) {
    _referenceDate = DateTime(year, month);
    notifyListeners();
  }
}
