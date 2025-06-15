import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:zcap_net_app/core/services/api_service.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ApiService.getItem with Entity', () {
    late MockClient mockClient;
    late ApiService apiService;

    setUp(() {
      AppConfig.initFromJson({
        "appDataPath": "/fake",
        "apiUrl": "https://fakeapi",
        "apiSyncIntervalSeconds": 6000,
        "logToFile": false,
        "logFileName": "log.txt"
      });
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);
    });

    test('returns an Entity if call completes successfully', () async {
      //Arrange
      const mockJsonResponse = '''
      {
        "entityId": 1,
        "name": "*TEST* Bombeiros Voluntários de Odivelas",
        "entityType": {
          "entityTypeId": 10,
            "name": "*TEST* Bombeiros 1113",
            "startDate": "2020-01-01",
            "endDate": "2025-12-31",
            "createdAt": "2025-06-02T23:11:25.080",
            "updatedAt": "2025-06-08T15:51:15.257"
          },
        "email": "test@bvodivelas.pt",
        "phone1": "21 934 82 90",
        "phone2": "",
        "startDate": "2023-01-01T00:00:00Z",
        "endDate": null,
        "createdAt": "2023-01-01T00:00:00Z",
        "updatedAt": "2023-01-01T00:00:00Z"
      }
      ''';

      when(
        mockClient.get(
          Uri.parse('https://fakeapi/entity/1'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response.bytes(utf8.encode(mockJsonResponse), 200),
      );

      //Act
      final json = await apiService.getItem('entity/1');
      final entity = Entity.fromJson(json);

      //Assert
      expect(entity, isA<Entity>());
      expect(entity.remoteId, 1);
      expect(entity.name, '*TEST* Bombeiros Voluntários de Odivelas');
      //expect(entity.entityType, isA<EntityType>);  //TODO: received a full object but internally Entity has only int
      expect(entity.entityTypeId, 10);
      expect(entity.email, 'test@bvodivelas.pt');
    });

    test('throws an exception if call completes with an error',
        () async {
      when(
        mockClient.get(
          Uri.parse('https://fakeapi/entity/1'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(
        () async => await apiService.getItem('entity/1'),
        throwsException,
      );
    });
  });
}


/*void main() {
  setUp(() {
    AppConfig.initFromJson({
      "appDataPath": "/fake",
      "apiUrl": "https://fakeapi.com",
      "apiSyncIntervalSeconds": 6000,
      "logToFile": false,
      "logFileName": "log.txt"
    });
  });

  group('fetchAlbum', () {
    test('returns an Album if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(
        client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')),
      ).thenAnswer(
        (_) async =>
            http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200),
      );

      expect(await fetchAlbum(client), isA<Album>());
    });
  );

  test('ApiService.getList returns list of objects', () async {

    final mockClient = MockClient((request) async {
      expect(request.url.toString(), 'https://fakeapi.com/test-endpoint');
      return http.Response(
        jsonEncode([
          {"id": 1, "name": "Item 1"},
          {"id": 2, "name": "Item 2"}
        ]),
        200,
      );
    });

  final apiService = ApiService(client: mockClient);

    final result = await apiService.getList(
      'test-endpoint',
      (json) => TestItem.fromJson(json),
    );

    expect(result.length, 2);
    expect(result[0].name, 'Item 1');
  });
}


//For getList tests
class TestItem {
  final int id;
  final String name;

  TestItem({required this.id, required this.name});

  factory TestItem.fromJson(Map<String, dynamic> json) =>
      TestItem(id: json['id'], name: json['name']);
}
*/