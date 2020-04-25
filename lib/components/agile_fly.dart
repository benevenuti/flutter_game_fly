import 'dart:ui';

import 'package:flame/sprite.dart';

import '../game_loop.dart';
import 'fly.dart';

class AgileFly extends Fly {
  double get speed => gameLoop.tileSize * 5;

  AgileFly(GameLoop gameLoop, double x, double y) : super(gameLoop, 1.5) {
    flyRect =
        Rect.fromLTWH(x, y, gameLoop.tileSize, gameLoop.tileSize);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite("flies/agile-fly-1.png"));
    flyingSprite.add(Sprite("flies/agile-fly-2.png"));
    deadSprite = Sprite("flies/agile-fly-dead.png");
    points = 20;

  }
}
