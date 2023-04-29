import 'package:flutter_test/flutter_test.dart';
import '../../lib/providers/dungeon_master_provider.dart';

void main() {
  group('DungeonMasterProvider', () {
    test('updateNickname should update the nickname', () {
      final dungeonMasterProvider = DungeonMasterProvider();

      dungeonMasterProvider.updateNickname('World');

      expect(dungeonMasterProvider.nickname, equals('World'));
    });
  });
}
