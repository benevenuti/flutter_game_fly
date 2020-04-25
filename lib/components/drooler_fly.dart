import 'dart:ui';

import 'package:flame/sprite.dart';

import '../game_loop.dart';
import 'fly.dart';

class DroolerFly extends Fly {
  DroolerFly(GameLoop gameLoop, double x, double y) : super(gameLoop) {
    flyRect =
        Rect.fromLTWH(x, y, gameLoop.tileSize * 1.5, gameLoop.tileSize * 1.5);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite("flies/drooler-fly-1.png"));
    flyingSprite.add(Sprite("flies/drooler-fly-2.png"));
    deadSprite = Sprite("flies/drooler-fly-dead.png");
  }
}
