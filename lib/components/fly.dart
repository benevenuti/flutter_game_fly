import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:fluttergamefly/game_loop.dart';

import '../view.dart';

class Fly {
  Rect flyRect;

  final GameLoop gameLoop;
  bool isDead = false;
  bool isOffScreen = false;

  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;

  double get speed => gameLoop.tileSize * 3;

  Offset targetLocation;

  Fly(this.gameLoop) {
    //toque

    setTargetLocation();
  }

  void setTargetLocation() {
    double x = gameLoop.rnd.nextDouble() *
        (gameLoop.screenSize.width - gameLoop.tileSize * 2.0);
    double y = gameLoop.rnd.nextDouble() *
        (gameLoop.screenSize.height - gameLoop.tileSize * 2.0);
    targetLocation = Offset(x, y);
  }

  void render(Canvas canvas) {
    if (isDead) {
      deadSprite.renderRect(canvas, flyRect.inflate(2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()]
          .renderRect(canvas, flyRect.inflate(2));
    }
  }

  void update(double t) {
    if (isDead) {
      flyRect = flyRect.translate(0, gameLoop.tileSize * 12 * t);
      if (flyRect.bottom > gameLoop.screenSize.height) {
        isOffScreen = true;
      }
    } else {
      flyingSpriteIndex += 30 * t;
      if (flyingSpriteIndex >= flyingSprite.length) {
        flyingSpriteIndex = flyingSpriteIndex - flyingSpriteIndex.toInt();
      }
      double stepDistance = speed * t;

      Offset toTarget = targetLocation - Offset(flyRect.left, flyRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget =
            Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(stepToTarget);
      } else {
        flyRect = flyRect.shift(toTarget);
        setTargetLocation();
      }
    }
  }

  void onTapDown() {
    if (!isDead) {
      isDead = true;

      if (gameLoop.activeView == View.playing) {
        gameLoop.score += 1;
      }
    }
  }
}
