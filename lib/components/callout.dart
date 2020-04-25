import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';

import '../bgm.dart';
import '../view.dart';
import 'fly.dart';

class Callout {
  final Fly fly;
  Rect rect;
  Sprite sprite;
  double value;

  TextPainter tp;
  TextStyle textStyle;
  Offset textOffset;

  Callout(this.fly) {
    sprite = Sprite('ui/callout.png');
    value = 1;
    tp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textStyle = TextStyle(
      color: Color(0xff000000),
      fontSize: 15,
    );
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
    tp.paint(canvas, textOffset);
  }

  void update(double time) {
    if (fly.gameLoop.activeView == View.playing) {
      value = value - .25 * time;
      if (value <= 0) {
        if (fly.gameLoop.soundButton.isEnabled) {
          Flame.audio.play('sfx/haha' +
              (fly.gameLoop.rnd.nextInt(5) + 1).toString() +
              '.ogg');
        }
        playMusic();
        fly.gameLoop.activeView = View.lost;
      }
    }

    rect = Rect.fromLTWH(
      fly.flyRect.left - (fly.gameLoop.tileSize * .25),
      fly.flyRect.top - (fly.gameLoop.tileSize * .5),
      fly.gameLoop.tileSize * .75,
      fly.gameLoop.tileSize * .75,
    );

    tp.text = TextSpan(
      text: (value * 10).toInt().toString(),
      style: textStyle,
    );

    tp.layout();

    textOffset = Offset(
      rect.center.dx - (tp.width / 2),
      rect.top + (rect.height * .4) - (tp.height / 2),
    );
  }

  void playMusic() async {
    if (fly.gameLoop.musicButton.isEnabled) {
      //await BGM.stop();
      await BGM.play(0);
    }
  }
}
