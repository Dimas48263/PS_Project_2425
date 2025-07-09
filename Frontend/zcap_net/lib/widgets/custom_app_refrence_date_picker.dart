import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:zcap_net_app/core/services/globals.dart';
import 'package:zcap_net_app/core/services/user/user_allowances_provider.dart';
import 'package:zcap_net_app/data/app_date_provider.dart';

class AppReferenceDateWidget extends StatelessWidget {
  const AppReferenceDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppReferenceDateProvider>(
      builder: (context, refDateProvider, _) {
        final referenceDate = refDateProvider.referenceDate;
        final formattedMonthYear =
            DateFormat.yMMMM(context.locale.toString()).format(referenceDate);
        final allowances = context.watch<UserAllowancesProvider>();

        return Row(
          children: [
            Text(formattedMonthYear, style: TextStyle(fontSize: 16)),
            IconButton(
              icon: Icon(Icons.calendar_today),
              tooltip: 'change_month'.tr(),
              onPressed: () async {
                if (allowances
                    .canWrite('user_access_change_app_reference_date')) {
                  final selectedDate = await showMonthPicker(
                    context: context,
                    initialDate: referenceDate,
                    firstDate: DateTime(1980),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    refDateProvider.setReferenceMonthYear(selectedDate.year, selectedDate.month);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
