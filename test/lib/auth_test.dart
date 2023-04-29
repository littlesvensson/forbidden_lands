import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../lib/models/http_exception.dart';
import '../../lib/providers/auth_provider.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('Auth', () {
    Auth auth;
    MockHttpClient client;

    setUp(() {
      auth = Auth();
      client = MockHttpClient();
    });

    test('isAuth should return false when token is null', () {
      expect(auth.isAuth, false);
    });

    test('userId should return null when it is not set', () {
      expect(auth.userId, null);
    });

    test('signup should call _authenticate with correct arguments', () async {
      when(client.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response('{"idToken": "dummyToken", "localId": "dummyUserId", "expiresIn": "3600"}', 200));
      auth.projectKey = 'dummyKey';
      await auth.signup('dummyEmail', 'dummyPassword');
      verify(client.post(Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signup?key=dummyKey'),
          body: json.encode({
            'email': 'dummyEmail',
            'password': 'dummyPassword',
            'returnSecureToken': true,
          }))).called(1);
    });

    test('login should call _authenticate with correct arguments', () async {
      when(client.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response('{"idToken": "dummyToken", "localId": "dummyUserId", "expiresIn": "3600"}', 200));
      auth.projectKey = 'dummyKey';
      await auth.login('dummyEmail', 'dummyPassword');
      verify(
          client.post(Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=dummyKey'),
              body: json.encode({
                'email': 'dummyEmail',
                'password': 'dummyPassword',
                'returnSecureToken': true,
              }))).called(1);
    });

    test('tryAutoLogin should return false when userData is not saved in SharedPreferences', () async {
      final prefs = MockSharedPreferences();
      when(prefs.containsKey('userData')).thenReturn(false);
      SharedPreferences.setMockInitialValues({});
      expect(await auth.tryAutoLogin(), false);
    });
  });
}
