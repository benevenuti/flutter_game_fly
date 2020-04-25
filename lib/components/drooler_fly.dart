import 'dart:ui';

import 'package:flame/sprite.dart';

import '../game_loop.dart';
import 'fly.dart';

class DroolerFly extends Fly {
  DroolerFly(GameLoop gameLoop, double x, double y) : super(gameLoop, 1.2) {
    flyRect =
        Rect.fromLTWH(x, y, gameLoop.tileSize, gameLoop.tileSize);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite("flies/drooler-fly-1.png"));
    flyingSprite.add(Sprite("flies/drooler-fly-2.png"));
    deadSprite = Sprite("flies/drooler-fly-dead.png");
  }
}
