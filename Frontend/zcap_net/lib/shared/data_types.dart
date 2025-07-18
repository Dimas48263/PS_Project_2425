import 'package:easy_localization/easy_localization.dart';

enum DataTypes {
  boolean,
  int,
  string,
  double,
  char,
  float;

  @override
  String toString() => name;

  String get example {
    switch (this) {
      case DataTypes.boolean:
        return 'true';
      case DataTypes.int:
        return '99';
      case DataTypes.string:
        return '"exemplo"';
      case DataTypes.double:
        return '3.14';
      case DataTypes.char:
        return "'A'";
      case DataTypes.float:
        return '3.14';
    }
  }

  String get label {
    switch (this) {
      case DataTypes.boolean:
        return 'boolean_label'.tr();
      case DataTypes.int:
        return 'int_label'.tr();
      case DataTypes.string:
        return 'string_label'.tr();
      case DataTypes.double:
        return 'double_label'.tr();
      case DataTypes.char:
        return 'char_label'.tr();
      case DataTypes.float:
        return 'float_label'.tr();
    }
  }

  bool validate(String value) {
    switch (this) {
      case DataTypes.string:
        return value.isNotEmpty;
      case DataTypes.int:
        return int.tryParseInt(value) != null;
      case DataTypes.double:
      case DataTypes.float:
        return double.tryParseDouble(value) != null;
      case DataTypes.boolean:
        return value == '0' || value == '1';
      case DataTypes.char:
        return value.length == 1;
    }
  }
}

extension DataTypesExtension on DataTypes {
  static DataTypes fromString(String value) {
    return DataTypes.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => DataTypes.string,
    );
  }
  
  tryParseInt(String value) => int.tryParse(value);
  tryParseDouble(String value) => double.tryParse(value);
}

