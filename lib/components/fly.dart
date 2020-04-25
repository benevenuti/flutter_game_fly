import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:fluttergamefly/game_loop.dart';

import '../view.dart';
import 'callout.dart';

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

  Callout callout;

  int points = 10;
  double flyTime;

  Fly(this.gameLoop, this.flyTime) {
    setTargetLocation();
    callout = Callout(this);
    callout.value = flyTime;
  }

  void setTargetLocation() {
    double x = gameLoop.rnd.nextDouble() *
        (gameLoop.screenSize.width - gameLoop.tileSize * 2.0);
    double y = gameLoop.rnd.nextDouble() *
        (gameLoop.screenSize.height - gameLoop.tileSize * 2.0);
    targetLocation = Offset(x, y);
  }

  void render(Canvas canvas) {
    //canvas.drawRect(flyRect.inflate(flyRect.width / 2), Paint()..color = Color(0x77ffffff));

    if (isDead) {
      deadSprite.renderRect(canvas, flyRect.inflate(flyRect.width / 2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()]
          .renderRect(canvas, flyRect.inflate(flyRect.width / 2));
      if (gameLoop.activeView == View.playing) {
        callout.render(canvas);
      }
    }

    //canvas.drawRect(flyRect, Paint()..color = Color(0x88000000));
  }

  void update(double time) {
    if (isDead) {
      flyRect = flyRect.translate(0, gameLoop.tileSize * 12 * time);
      if (flyRect.bottom > gameLoop.screenSize.height) {
        isOffScreen = true;
      }
    } else {
      flyingSpriteIndex += 30 * time;
      if (flyingSpriteIndex >= flyingSprite.length) {
        flyingSpriteIndex = flyingSpriteIndex - flyingSpriteIndex.toInt();
      }
      double stepDistance = speed * time;

      Offset toTarget = targetLocation - Offset(flyRect.left, flyRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget =
            Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(stepToTarget);
      } else {
        flyRect = flyRect.shift(toTarget);
        setTargetLocation();
      }

      callout.update(time);

      gameLoop.flies.forEach((otherFly) {
        if (otherFly != this &&
            !this.isDead &&
            !otherFly.isDead &&
            flyRect.overlaps(otherFly.flyRect)
        ) {
          otherFly.isDead = true;
          isDead = true;
        }
      });

    }
  }

  void onTapDown() {
    if (!isDead) {
      isDead = true;

      if (gameLoop.soundButton.isEnabled) {
        Flame.audio.play(
            'sfx/ouch' + (gameLoop.rnd.nextInt(11) + 1).toString() + '.ogg');
      }

      if (gameLoop.activeView == View.playing) {
        gameLoop.score += this.points;

        if (gameLoop.score > (gameLoop.storage.getInt('highscore') ?? 0)) {
          gameLoop.storage.setInt('highscore', gameLoop.score);
          gameLoop.highscoreDisplay.updateHighscore();
        }
      }
    }
  }
}
