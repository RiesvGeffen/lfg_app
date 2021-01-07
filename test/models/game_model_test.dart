import 'package:flutter_test/flutter_test.dart';
import 'package:lfg_app/models/game_model.dart';

void main() {
  group("Game model", () {
    Map<String, dynamic> testJson = Map<String, dynamic>();
    testJson.addAll({"title": "Test title", "image": "fakeurl"});
    final testId = "a1b2c3";

    test('Name should be "Test title"', () {
      final game = Game.fromJson(testJson, testId);

      expect(game.title, "Test title");
    });

    test('Image should be "fakeurl"', () {
      final game = Game.fromJson(testJson, testId);

      expect(game.image, "fakeurl");
    });

    test('Id should be "a1b2c3"', () {
      final game = Game.fromJson(testJson, testId);

      expect(game.id, "a1b2c3");
    });
  });
}
