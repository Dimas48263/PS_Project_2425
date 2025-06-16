/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zcap_net_app/features/login/view_model/language_model.dart';

class LanguageSelector extends StatelessWidget {
  Future<List<Language>> loadLanguages() async {
    final jsonStr = await rootBundle.loadString('assets/translations/languages.json');
    final List<dynamic> data = json.decode(jsonStr);
    return data.map((e) => Language.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Language')),
      body: FutureBuilder<List<Language>>(
        future: loadLanguages(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final languages = snapshot.data!;
          return ListView.builder(
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final lang = languages[index];
              return ListTile(
                leading: Image.asset(lang.flag, width: 32),
                title: Text(lang.name),
                onTap: () {
                  context.setLocale(Locale(lang.code));
                  Navigator.pop(context); // volta ao ecrã anterior
                },
              );
            },
          );
        },
      ),
    );
  }
}
*/