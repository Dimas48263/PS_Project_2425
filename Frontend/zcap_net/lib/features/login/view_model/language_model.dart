import 'dart:convert';

import 'package:flutter/services.dart';

class Language {
  final String code;
  final String name;
  final String flag;

  Language({
    required this.code,
    required this.name,
    required this.flag,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'],
      name: json['name'],
      flag: json['flag'],
    );
  }

  static Future<List<Language>> loadFromAsset() async {
    final jsonStr =
        await rootBundle.loadString('assets/translations/languages.json');
    final List<dynamic> data = json.decode(jsonStr);
    return data.map((e) => Language.fromJson(e)).toList();
  }
}
