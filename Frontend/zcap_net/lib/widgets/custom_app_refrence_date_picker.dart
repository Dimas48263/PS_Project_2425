import 'package:flutter/material.dart';
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
        final formattedDate =
            DateFormat('yyyy-MM-dd').format(refDateProvider.referenceDate);
        final allowances = context.watch<UserAllowancesProvider>();

        return Row(
          children: [
            Text(formattedDate, style: TextStyle(fontSize: 16)),
            IconButton(
              icon: Icon(Icons.calendar_today),
              tooltip: 'change_date'.tr(),
              onPressed: () async {
                if (allowances.canWrite('user_access_change_app_reference_date')) {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: refDateProvider.referenceDate,
                    firstDate: DateTime(1980),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    refDateProvider.setReferenceDate(selectedDate);
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
