/*class DataType implements ApiTable {
   @override
  int remoteId;
  final String name;
  @override 
  final DateTime lastUpdatedAt;

  DataType({
    required this.remoteId,
    required this.name,
    required this.lastUpdatedAt
  });

  factory DataType.fromJson(Map<String, dynamic> json) {
    return DataType(
      remoteId: json['id'],
      name: json['name'],
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'name': name,
    };
  }

  DataType copyWith({
    int? id,
    String? name,
    DateTime? lastUpdatedAt
  }) {
    return DataType(
      remoteId: id ?? remoteId,
      name: name ?? this.name,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt
    );
  }
  
}*/

enum DataTypes {
  boolean,
  int,
  string,
  double,
  char,
  float;

  @override
  String toString() => name;
}

extension DataTypesExtension on DataTypes {
  static DataTypes fromString(String value) {
    return DataTypes.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => DataTypes.string,
    );
  }
}