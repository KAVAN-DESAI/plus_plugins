import 'dart:async';

import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';
import 'package:battery_plus/battery_plus_plugin_bindings.dart';
import 'package:jni/jni.dart';

/// The Android implementation of BatteryPlatform.
class BatteryPlusAndroidPlugin extends BatteryPlatform {
  /// Register this dart class as the platform implementation for Android
  static void registerWith() {
    BatteryPlatform.instance = BatteryPlusAndroidPlugin();
  }

  /// Returns the current battery level in percent.
  @override
  Future<int> get batteryLevel{
    JObject activity = JObject.fromRef(Jni.getCurrentActivity());
    BatteryPlusPlugin batteryPlusPlugin = BatteryPlusPlugin(activity);
    return Future.value(int.parse(batteryPlusPlugin.getBatteryLevel().toDartString()));
  }

  /// Returns the current battery state.
  @override
  Future<BatteryState> get batteryState {
    JObject activity = JObject.fromRef(Jni.getCurrentActivity());
    BatteryPlusPlugin batteryPlusPlugin = BatteryPlusPlugin(activity);
    return Future.value(parseBatteryState(batteryPlusPlugin.getBatteryStatus().toDartString()));
  }

  /// Returns true if the device is on battery save mode
  Future<bool> get isInBatterySaveMode {
    JObject activity = JObject.fromRef(Jni.getCurrentActivity());
    BatteryPlusPlugin batteryPlusPlugin = BatteryPlusPlugin(activity);
    return Future.value(batteryPlusPlugin.isInPowerSaveMode().booleanValue());
  }

  /// Method for parsing battery state.
  BatteryState parseBatteryState(String state) {
    switch (state) {
      case 'full':
        return BatteryState.full;
      case 'charging':
        return BatteryState.charging;
      case 'discharging':
        return BatteryState.discharging;
      case 'unknown':
        return BatteryState.unknown;
      default:
        throw ArgumentError('$state is not a valid BatteryState.');
    }
  }

  /// Fires whenever the battery state changes.
  @override
  Stream<BatteryState> get onBatteryStateChanged {
    return Stream.empty();
  }
}
