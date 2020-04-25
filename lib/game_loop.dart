import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttergamefly/components/backyard.dart';
import 'package:fluttergamefly/view.dart';
import 'package:fluttergamefly/views/credits-view.dart';
import 'package:fluttergamefly/views/help-view.dart';
import 'package:fluttergamefly/views/home-view.dart';
import 'package:fluttergamefly/views/lost-view.dart';

import 'components/agile_fly.dart';
import 'components/credits-button.dart';
import 'components/drooler_fly.dart';
import 'components/fly.dart';
import 'components/help-button.dart';
import 'components/house_fly.dart';
import 'components/hungry_fly.dart';
import 'components/macho_fly.dart';
import 'components/score-display.dart';
import 'components/start-button.dart';
import 'controllers/spawner.dart';

class GameLoop extends Game {
  View activeView = View.home;

  Size screenSize;
  double tileSize;
  Backyard backyard;
  List<Fly> flies;
  Random rnd;

  HomeView homeView;
  LostView lostView;
  HelpView helpView;
  CreditsView creditsView;
  ScoreDisplay scoreDisplay;

  FlySpawner spawner;

  StartButton startButton;
  HelpButton helpButton;
  CreditsButton creditsButton;

  int score;

  GameLoop() {
    initialize();
  }

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());

    backyard = Backyard(this);

    homeView = HomeView(this);
    lostView = LostView(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);

    scoreDisplay = ScoreDisplay(this);

    startButton = StartButton(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);

    spawner = FlySpawner(this);

    score = 0;
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize * 2.0);
    double y = rnd.nextDouble() * (screenSize.height - tileSize * 2.0);

    int randInt = rnd.nextInt(5);

    switch (randInt) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(AgileFly(this, x, y));
        break;
      case 2:
        flies.add(HungryFly(this, x, y));
        break;
      case 3:
        flies.add(DroolerFly(this, x, y));
        break;
      case 4:
        flies.add(MachoFly(this, x, y));
        break;
    }
  }

  @override
  void render(Canvas canvas) {
    backyard.render(canvas);

    if (activeView == View.playing) scoreDisplay.render(canvas);

    flies.forEach((fly) {
      fly.render(canvas);
    });

    if (activeView == View.help) helpView.render(canvas);

    if (activeView == View.credits) creditsView.render(canvas);

    if (activeView == View.home) homeView.render(canvas);

    if (activeView == View.lost) lostView.render(canvas);

    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }
  }

  @override
  void update(double time) {
    flies.forEach((fly) {
      fly.update(time);
    });

    flies.removeWhere((fly) => fly.isOffScreen);

    spawner.update(time);

    if (activeView == View.playing) scoreDisplay.update(time);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails details) {
    // dialogs
    if (activeView == View.help || activeView == View.credits) {
      activeView = View.home;
      return;
    }

    // start
    if (startButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        return;
      }
    }

    // help
    if (helpButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        return;
      }
    }

    // credits
    if (creditsButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        return;
      }
    }

    bool didHitAFly = false;

    flies.forEach((fly) {
      if (fly.flyRect.contains(details.globalPosition) && !fly.isDead) {
        fly.onTapDown();
        didHitAFly = true;
        return;
      }
    });

    if (activeView == View.playing && !didHitAFly) {
      activeView = View.lost;
    }
  }
}
