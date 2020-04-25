import 'dart:ui';

import 'package:flame/sprite.dart';

import '../game_loop.dart';
import 'fly.dart';

class HouseFly extends Fly {
  HouseFly(GameLoop gameLoop, double x, double y) : super(gameLoop, 2) {
    flyRect =
        Rect.fromLTWH(x, y, gameLoop.tileSize, gameLoop.tileSize);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite("flies/house-fly-1.png"));
    flyingSprite.add(Sprite("flies/house-fly-2.png"));
    deadSprite = Sprite("flies/house-fly-dead.png");
  }
}
