import 'package:device_info_plus/src/model/android_device_info.dart';
import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';

class AndroidInfo {
  dynamic platform;
  AndroidInfo({required this.platform});

  /// This information does not change from call to call. Cache it.
  AndroidDeviceInfo? _cachedAndroidDeviceInfo;

  Future<AndroidDeviceInfo> get info async =>
      _cachedAndroidDeviceInfo ??=
          AndroidDeviceInfo.fromMap((await platform.deviceInfo()).data);
}
