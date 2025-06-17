import 'package:flutter/material.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/shared/shared.dart';

class DateUtilsService {
  const DateUtilsService();

  bool validateStartEndDate({
    required DateTime startDate,
    DateTime? endDate,
    required BuildContext context,
  }) {
    if (endDate != null && endDate.isBefore(startDate)) {
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'error'.tr(),
          content: 'error_enddate_less_than_startdate'.tr(),
        ),
      );
      return false;
    }
    return true;
  }
}
