import 'dart:convert';
import 'dart:io';

import 'package:intel_geti_api/intel_geti_api.dart';
import 'package:test/test.dart';

/// Function to read in JSON file with test information.
Future<Map<String, dynamic>> readJsonFile(String filePath) async {
  var input = await File(filePath).readAsString();
  var map = jsonDecode(input);
  return map as Map<String, dynamic>;
}

void main() {
  group("Authentication API", () {
    late String testServer;
    late String testUserId;
    late String testPassword;
    setUp(() async {
      Map<String, dynamic> map =
          await readJsonFile('test/resources/secrets.json');
      testServer = map['TEST_IP_SERVER'];
      testUserId = map['TEST_USER_ID'];
      testPassword = map['TEST_PASSWORD'];
    });

    test('is successful with correct credentials', () async {
      Map<String, dynamic> data = {
        'login': testUserId,
        'password': testPassword
      };
      IntelGetiClient geti =
          IntelGetiClient(getiServerURL: testServer, userID: testUserId);
      expect(true, await geti.authenticate(data));
    });

    test('is unsuccessful with incorrect credentials', () async {
      Map<String, dynamic> data = {
        'login': testUserId,
        'password': 'INCORRECT-PASSWORD'
      };
      IntelGetiClient geti =
          IntelGetiClient(getiServerURL: testServer, userID: testUserId);
      expect(false, await geti.authenticate(data));
    });
  });

  group("Workspaces API", () {
    late IntelGetiClient geti;
    setUp(() async {
      Map<String, dynamic> map =
          await readJsonFile('test/resources/secrets.json');
      String testServer = map['TEST_IP_SERVER'];
      String testUserId = map['TEST_USER_ID'];
      String testPassword = map['TEST_PASSWORD'];
      Map<String, dynamic> data = {
        'login': testUserId,
        'password': testPassword
      };
      geti = IntelGetiClient(getiServerURL: testServer, userID: testUserId);
      expect(true, await geti.authenticate(data));
    });

    test('to get information about all workspaces is successful.', () async {
      List<Workspace> workspaces = await geti.getWorkspaces();
      expect(true, workspaces.isNotEmpty);
    });
  });

  group("Projects API", () {
    late IntelGetiClient geti;
    setUp(() async {
      Map<String, dynamic> map =
          await readJsonFile('test/resources/secrets.json');
      String testServer = map['TEST_IP_SERVER'];
      String testUserId = map['TEST_USER_ID'];
      String testPassword = map['TEST_PASSWORD'];
      Map<String, dynamic> data = {
        'login': testUserId,
        'password': testPassword
      };
      geti = IntelGetiClient(getiServerURL: testServer, userID: testUserId);
      expect(true, await geti.authenticate(data));
    });

    group('to create a project', () {
      test('is successful.', () async {
        List<Workspace> workspaces = await geti.getWorkspaces();
        expect(true, workspaces.isNotEmpty);
      });
    });
  });
}
