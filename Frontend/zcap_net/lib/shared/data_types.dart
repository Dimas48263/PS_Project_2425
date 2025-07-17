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
}

extension DataTypesExtension on DataTypes {
  static DataTypes fromString(String value) {
    return DataTypes.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => DataTypes.string,
    );
  }
}