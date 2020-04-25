import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:fluttergamefly/game_loop.dart';

import '../bgm.dart';
import '../view.dart';

class MusicButton {
  final GameLoop game;
  Rect rect;
  Sprite enabledSprite;
  Sprite disabledSprite;
  bool isEnabled = true;

  MusicButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * .25,
      game.tileSize * .25,
      game.tileSize,
      game.tileSize,
    );
    enabledSprite = Sprite('ui/icon-music-enabled.png');
    disabledSprite = Sprite('ui/icon-music-disabled.png');
  }

  void render(Canvas c) {
    if (isEnabled) {
      enabledSprite.renderRect(c, rect);
    } else {
      disabledSprite.renderRect(c, rect);
    }
  }

  void onTapDown() {
    if (isEnabled) {
      isEnabled = false;
      BGM.stop();
    } else {
      isEnabled = true;
      if (game.activeView == View.playing) {
        BGM.play(1);
      }
      else {
        BGM.play(0);
      }
    }
  }
}
