import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../lib/providers/auth_provider.dart';
import '../../lib/providers/games_provider.dart';

class MockAuth extends Mock implements Auth {}

class MockClient extends Mock implements http.Client {}

void main() {
  group('GamesProvider', () {
    test('fetchGames returns list of games', () async {
      final mockAuth = MockAuth();
      final mockClient = MockClient();
      final gamesProvider = GamesProvider(mockAuth);

      when(mockAuth.token).thenReturn('test_token');
      when(mockAuth.userId).thenReturn('test_userId');
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('{}', 200));

      final games = await gamesProvider.fetchGames(mockAuth);

      expect(games, isList);
    });

    test('fetchGamePlayers returns list of players', () async {
      final mockAuth = MockAuth();
      final mockClient = MockClient();
      final gamesProvider = GamesProvider(mockAuth);

      when(mockAuth.token).thenReturn('test_token');
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('{"1": "player1", "2": "player2"}', 200));

      final players = await gamesProvider.fetchGamePlayers('test_game_id');

      expect(players, isList);
      expect(players, hasLength(2));
    });

    test('addNewGame adds new game', () async {
      final mockAuth = MockAuth();
      final mockClient = MockClient();
      final gamesProvider = GamesProvider(mockAuth);

      when(mockAuth.token).thenReturn('test_token');
      when(mockAuth.userId).thenReturn('test_userId');
      when(mockClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{"name": "test_game_name", "password": "test_password"}', 200));

      await gamesProvider.addNewGame('test_game_name', mockAuth);

      expect(gamesProvider.games, hasLength(1));
    });
  });
}
