import 'package:appmetrica_plugin/appmetrica_plugin.dart';

import 'dart:developer' as developer;

class Log {
  static final Log instance = Log._internal();
  Log._internal();

  bool _initialize = false;
  Future<void> get _init async {
    //removable
    try {
      await AppMetrica.activate(const AppMetricaConfig(
        "eba13b4c-bf4b-4ea5-8f9f-50452940591e",
        appVersion: '0.0.2',
      ));
    } catch (e) {
      developer.log(e.toString());
    }
    _initialize = true;
  }

  void log(String data, {bool hide = false}) async {
    if (!hide) {
      developer.log(data);
    }
    if (!_initialize) {
      await _init;
    }
    //removable
    await AppMetrica.reportEvent(data);
  }
}
