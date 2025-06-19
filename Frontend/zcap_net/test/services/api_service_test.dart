import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:zcap_net_app/core/services/app_config.dart';
import 'package:zcap_net_app/features/settings/models/entities/entities/entities.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:zcap_net_app/core/services/api_service.dart';
import 'package:zcap_net_app/features/settings/models/entities/entity_types/entity_type.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late ApiService apiService;

  setUp(() {
    AppConfig.initFromJson({
      "appDataPath": "/fake",
      "apiUrl": "http://fakeapi",
      "apiSyncIntervalSeconds": 6000,
      "logToFile": false,
      "logFileName": "log.txt"
    });
    mockClient = MockClient();
    apiService = ApiService(client: mockClient);
  });

  group('apiService.getList', () {
    test('returns an array of Entities when completes with success', () async {
      const mockJsonResponse = '''
  [
    {
      "entityId": 666,
      "name": "Policia Municipal",
      "entityType": {
          "entityTypeId": 888,
            "name": "*TEST* 888",
            "startDate": "2020-01-01",
            "endDate": "2025-12-31",
            "createdAt": "2025-06-02T23:11:25.080",
            "lastUpdatedAt": "2025-06-08T15:51:15.257"
          },
      "email": "",
      "phone1": "351 21 000 000",
      "phone2": "",
      "startDate": "2025-01-01T00:00:00Z",
      "endDate": null,
      "createdAt": "2025-01-01T00:00:00Z",
      "lastUpdatedAt": "2025-01-01T00:00:00Z"
    },
    {
      "entityId": 777,
      "name": "Cruz Vermelha",
      "entityType": {
        "entityTypeId": 555,
          "name": "*TEST* 555",
          "startDate": "2020-01-01",
          "endDate": "2025-12-31",
          "createdAt": "2025-06-02T23:11:25.080",
          "lastUpdatedAt": "2025-06-08T15:51:15.257"
      },
      "email": "",
      "phone1": "351 21 000 000",
      "phone2": "",
      "startDate": "2025-01-01T00:00:00Z",
      "endDate": null,
      "createdAt": "2025-01-01T00:00:00Z",
      "lastUpdatedAt": "2025-01-01T00:00:00Z"
    }
  ]
  ''';

      when(
        mockClient.get(
          Uri.parse('http://fakeapi/entities'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response.bytes(utf8.encode(mockJsonResponse), 200),
      );

      final result = await apiService.getList('entities', Entity.fromJson);

      expect(result, isA<List<Entity>>());
      expect(result.length, 2);
      expect(result.first.remoteId, 666);
      expect(result[1].entityType.remoteId, 555);
    });

    test('returns an empty array', () async {
      const mockJsonResponse = '''[]''';

      when(
        mockClient.get(
          Uri.parse('http://fakeapi/entities'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response.bytes(utf8.encode(mockJsonResponse), 200),
      );

      final result = await apiService.getList('entities', Entity.fromJson);

      expect(result.length, 0);
    });
  });
  group('apiService.getItem', () {
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
            "lastUpdatedAt": "2025-06-08T15:51:15.257"
          },
        "email": "test@bvodivelas.pt",
        "phone1": "21 934 82 90",
        "phone2": "",
        "startDate": "2025-01-01T00:00:00Z",
        "endDate": null,
        "createdAt": "2025-01-01T00:00:00Z",
        "lastUpdatedAt": "2025-01-01T00:00:00Z"
      }
      ''';

      when(
        mockClient.get(
          Uri.parse('http://fakeapi/entity/1'),
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
      expect(entity.entityType,
          isA<EntityType>());
      expect(entity.entityType.remoteId, 10);
      expect(entity.email, 'test@bvodivelas.pt');
    });

    test('throws an exception if call completes with an error', () async {
      when(
        mockClient.get(
          Uri.parse('http://fakeapi/entity/1'),
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

  group('apiService.post', () {
    test('post request returns created Entity', () async {
      const responseJson = '''
  {
    "entityId": 999,
    "name": "TEST New Entity",
    "entityType": {
        "entityTypeId": 10,
          "name": "*TEST* Bombeiros 1113",
          "startDate": "2020-01-01",
          "endDate": "2025-12-31",
          "createdAt": "2025-06-02T23:11:25.080",
          "lastUpdatedAt": "2025-06-08T15:51:15.257"
        },
    "email": "test@bvodivelas.pt",
    "phone1": "999",
    "phone2": "",
    "startDate": "2025-01-01T00:00:00Z",
    "endDate": null,
    "createdAt": "2025-01-01T00:00:00Z",
    "lastUpdatedAt": "2025-01-01T00:00:00Z"
  }
  ''';

      final entityToCreate = {
        'name': "TEST New Entity",
        'entityTypeId': 17,
        'phone1': "352 11111111",
        'startDate': "2025-01-01T00:00:00.000Z",
        'endDate': null,
      };

      when(
        mockClient.post(
          Uri.parse('http://fakeapi/entity'),
          headers: anyNamed('headers'),
          body: json.encode(entityToCreate),
        ),
      ).thenAnswer(
        (_) async => http.Response.bytes(utf8.encode(responseJson), 201),
      );

      final result = await apiService.post('entity', entityToCreate);
      final newEntity = Entity.fromJson(result);

      expect(newEntity, isA<Entity>());
      expect(newEntity.entityType,
          isA<EntityType>());
      expect(newEntity.name, 'TEST New Entity');
    });
  });

  group('apiService.put', () {
    final updatedEntity = {
      "name": "Updated Entity",
      "entityTypeId": 444,
      "email": "test@bvodivelas.pt",
      "phone1": "123456789",
      "phone2": "",
      "startDate": "2025-01-01T00:00:00Z",
      "endDate": null,
    };
    test('using PUT to update a record', () async {
      const updatedJson = '''
        {
          "entityId": 333,
          "name": "Updated Entity",
            "entityType": {
              "entityTypeId": 444,
                "name": "*TEST* Bombeiros 1113",
                "startDate": "2020-01-01",
                "endDate": "2025-12-31",
                "createdAt": "2025-06-02T23:11:25.080",
                "lastUpdatedAt": "2025-06-08T15:51:15.257"
              },
          "email": "test@bvodivelas.pt",
          "phone1": "123456789",
          "phone2": "",
          "startDate": "2025-01-01T00:00:00Z",
          "endDate": null,
          "createdAt": "2025-01-01T00:00:00Z",
          "lastUpdatedAt": "2025-06-01T00:00:00Z"
        }
      ''';

      when(
        mockClient.put(
          Uri.parse('http://fakeapi/entity/333'),
          headers: anyNamed('headers'),
          body: json.encode(updatedEntity),
        ),
      ).thenAnswer(
        (_) async => http.Response.bytes(utf8.encode(updatedJson), 200),
      );

      final result = await apiService.put('entity/333', updatedEntity);
      final entity = Entity.fromJson(result);

      expect(entity.name, 'Updated Entity');
      expect(entity.remoteId, 333);
      expect(entity.entityType.remoteId, 444);
      expect(entity.phone1, '123456789');
    });

    test('PUT request fails with 400', () async {
      when(
        mockClient.put(
          Uri.parse('http://fakeapi/entity/333'),
          headers: anyNamed('headers'),
          body: json.encode(updatedEntity),
        ),
      ).thenAnswer(
        (_) async => http.Response('Bad Request', 400),
      );

      expect(
        () async => await apiService.put('entity/333', updatedEntity),
        throwsA(isA<Exception>()),
      );
    });
  });
}
