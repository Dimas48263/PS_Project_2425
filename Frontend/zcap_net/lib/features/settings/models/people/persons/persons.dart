import 'package:zcap_net_app/core/services/remote_table.dart';
import 'package:zcap_net_app/features/settings/models/people/departure_destination/departure_destination.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree/tree.dart';
import 'package:zcap_net_app/features/settings/models/trees/tree_record_details/tree_record_detail.dart';

class Persons implements ApiTable {
  @override
  int remoteId;
  final String name;
  final int age;
  final String contact;
  final Tree placeOfResidence;
  final DateTime entryDateTime;
  final String technicianName;
  int? bedNumber;
  DateTime? departureDateTime;
  DateTime? birthDate;
  TreeRecordDetail? nationality;
  String? address;
  String? niss;
  DepartureDestination? departureDestination;
  String? destinationContact;

  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  Persons({
    required this.remoteId,
    required this.name,
    required this.age,
    required this.contact,
    required this.placeOfResidence,
    required this.entryDateTime,
    required this.technicianName,
    this.bedNumber,
    this.departureDateTime,
    this.birthDate,
    this.nationality,
    this.address,
    this.niss,
    this.departureDestination,
    this.destinationContact,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory Persons.fromJson(Map<String, dynamic> json) {
    return Persons(
      remoteId: json['personId'],
      name: json['name'],
      age: json['age'],
      contact: json['contact'],
      placeOfResidence: Tree.fromJson(json['placeOfResidence']),
      entryDateTime: DateTime.parse(json['entryDateTime']),
      technicianName: json['technicianName'],
      bedNumber: json['bedNumber'],
      departureDateTime: json['departureDateTime'] != null
          ? DateTime.parse(json['departureDateTime'])
          : null,
      birthDate:
          json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      nationality: json['nationality'] != null
          ? TreeRecordDetail.fromJson(json['nationality'])
          : null,
      address: json['address'],
      niss: json['niss'],
      departureDestination: json['departureDestination'] != null
          ? DepartureDestination.fromJson(json['departureDestination'])
          : null,
      destinationContact: json['destinationContact'],
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJsonInput() {
    return {
      'name': name,
      'age': age,
      'contact': contact,
      'placeOfResidenceId': placeOfResidence.remoteId,
      'entryDateTime': entryDateTime.toIso8601String(),
      'technicianName': technicianName,
      'bedNumber': bedNumber,
      'departureDateTime': departureDateTime?.toIso8601String(),
      'birthDate': birthDate?.toIso8601String(),
      'nationalityId': nationality?.remoteId,
      'address': address,
      'niss': niss,
      'departureDestinationId': departureDestination?.remoteId,
      'destinationContact': destinationContact,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJsonInputAsync() async {
    return {
      'name': name,
      'age': age,
      'contact': contact,
      'placeOfResidenceId': placeOfResidence.remoteId,
      'entryDateTime': entryDateTime.toIso8601String(),
      'technicianName': technicianName,
      'bedNumber': bedNumber,
      'departureDateTime': departureDateTime?.toIso8601String(),
      'birthDate': birthDate?.toIso8601String(),
      'nationalityId': nationality?.remoteId,
      'address': address,
      'niss': niss,
      'departureDestinationId': departureDestination?.remoteId,
      'destinationContact': destinationContact,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }

  Persons copyWith({
    int? remoteId,
    String? name,
    int? age,
    String? contact,
    Tree? placeOfResidence,
    DateTime? entryDateTime,
    String? technicianName,
    int? bedNumber,
    DateTime? departureDateTime,
    DateTime? birthDate,
    TreeRecordDetail? nationality,
    String? address,
    String? niss,
    DepartureDestination? departureDestination,
    String? destinationContact,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return Persons(
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      age: age ?? this.age,
      contact: contact ?? this.contact,
      placeOfResidence: placeOfResidence ?? this.placeOfResidence,
      entryDateTime: entryDateTime ?? this.entryDateTime,
      technicianName: technicianName ?? this.technicianName,
      bedNumber: bedNumber ?? this.bedNumber,
      departureDateTime: departureDateTime ?? this.departureDateTime,
      birthDate: birthDate ?? this.birthDate,
      nationality: nationality ?? this.nationality,
      address: address ?? this.address,
      niss: niss ?? this.niss,
      departureDestination: departureDestination ?? this.departureDestination,
      destinationContact: destinationContact ?? this.destinationContact,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
