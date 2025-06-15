import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zcap_net_app/shared/shared.dart';

void main() {
  late DateUtilsService service;

  setUp(() {
    service = const DateUtilsService();
  });

  Future<BuildContext> getContext(WidgetTester tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          key: key,
          builder: (context) => const Scaffold(body: SizedBox()),
        ),
      ),
    );
    return key.currentContext!;
  }

  testWidgets('endDate = null: retorna true', (tester) async {
    final ctx = await getContext(tester);
    final result = service.validateStartEndDate(
      startDate: DateTime(2025, 1, 1),
      endDate: null,
      context: ctx,
    );
    expect(result, isTrue);
  });

  testWidgets('endDate >= startDate: retorna true', (tester) async {
    final ctx = await getContext(tester);
    final result = service.validateStartEndDate(
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 12, 31),
      context: ctx,
    );
    expect(result, isTrue);
  });

  testWidgets('endDate < startDate: retorna false e caixa de dialogo', (tester) async {
    final ctx = await getContext(tester);
    final result = service.validateStartEndDate(
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2024, 12, 31),
      context: ctx,
    );
    expect(result, isFalse);
    await tester.pumpAndSettle();
    expect(find.byType(CustomAlertDialog), findsOneWidget);
  });
}
