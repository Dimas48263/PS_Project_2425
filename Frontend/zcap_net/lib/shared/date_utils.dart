import 'package:flutter/material.dart';
import 'package:zcap_net_app/shared/shared.dart';

class DateUtilsService {
  static bool validateStartEndDate({
    required DateTime startDate,
    DateTime? endDate,
    required BuildContext context,
  }) {
    if (endDate != null && endDate.isBefore(startDate)) {
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'Erro',
          content: 'A data de fim não pode ser anterior à data de início.',
        ),
      );
      return false;
    }
    return true;
  }
}
