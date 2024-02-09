import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:avnetman/enemy/ghost_spritesheet.dart';
import 'package:avnetman/util/sounds.dart';

class GameState extends ChangeNotifier {
  final Duration _timePower = const Duration(seconds: 10);
  List<ValueChanged<bool>> onChangePowerObserves = [];
  late Timer _powerTimer = Timer(const Duration(days: 40000), () {});

  int _score = 0;
  int _lifes = 3;
  Uint8List _lastScanRaw = Uint8List(0);
  Uint8List _lastScanProc = Uint8List(0);
  String _lastTextResult = "";
  bool _scanOn = false;
  bool _pacManWithPower = false;

  bool get pacManWithPower => _pacManWithPower;
  int get score => _score;
  int get lifes => _lifes;
  Uint8List get lastScanRaw => _lastScanRaw;
  Uint8List get lastScanProc => _lastScanProc;
  String get lastTextResult => _lastTextResult;

  bool get hasLastScanRaw => _lastScanRaw.isNotEmpty;
  bool get hasLastScanProc => _lastScanProc.isNotEmpty;
  bool get scanOn => _scanOn;

  void setScanStatus(bool status) {
    _scanOn = status;
    notifyListeners();
  }

  void setScanImageRaw(Uint8List inp) {
    _lastScanRaw = inp;
    notifyListeners();
  }

  void setScanImageProc(Uint8List inp) {
    _lastScanProc = inp;
    notifyListeners();
  }

  void setTextResult(String inp) {
    _lastTextResult = inp;
    notifyListeners();
  }

  void incrementScore({int value = 10}) {
    _score += value;
    notifyListeners();
  }

  void decrementScore(int value) {
    _score -= value;
    notifyListeners();
  }

  void decrementLife() {
    _lifes -= 1;
    notifyListeners();
  }

  void startPacManPower() {
    _powerTimer.cancel();
    _pacManWithPower = true;
    for (var element in onChangePowerObserves) {
      element(_pacManWithPower);
    }
    Sounds.playPowerBackgroundSound();
    _powerTimer = Timer(_timePower, () {
      _pacManWithPower = false;
      for (var element in onChangePowerObserves) {
        element(_pacManWithPower);
      }
      Sounds.stopBackgroundSound();
      notifyListeners();
    });
    notifyListeners();
  }

  void listenChangePower(ValueChanged<bool> onChange) {
    onChangePowerObserves.add(onChange);
  }

  void reset() {
    _score = 0;
    _lifes = 3;
    _lastScanProc = Uint8List(0);
    _lastScanRaw = Uint8List(0);
    _scanOn = false;
    onChangePowerObserves.clear();
    _powerTimer.cancel();
    GhostSpriteSheet.reshuffle();
  }
}
