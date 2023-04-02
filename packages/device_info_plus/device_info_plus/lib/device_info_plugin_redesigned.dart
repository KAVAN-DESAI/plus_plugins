import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_info_plus/src/api/api.dart';
import 'package:device_info_plus/src/api/device_info_interface/request/android_info_request.dart';
import 'package:device_info_plus/src/api/device_info_interface/request/ios_info_request.dart';
import 'package:device_info_plus/src/api/device_info_interface/request/linux_info_request.dart';
import 'package:device_info_plus/src/api/device_provider.dart';
import 'package:device_info_plus/src/model/android_device_info.dart';
import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';

sealed class Device {
}

class Android implements Device {
  Future<AndroidDeviceInfo> getInfo(dynamic platform, bool convertToMap)async{
    final AndroidInfo androidInfo = AndroidInfo(platform: platform);
    return await androidInfo.info;
  }
}

class IOS implements Device {
  Future<IosDeviceInfo> getInfo(dynamic platform, bool convertToMap) async{
    final IosInfo isoInfo = IosInfo(platform: platform);
    return await isoInfo.info;
  }
}

class Linux implements Device {
  Future<dynamic> getInfo(dynamic platform, bool convertToMap) async{
    final LinuxInfo linuxInfo = LinuxInfo(platform: platform);
    return await linuxInfo.info(convertToMap);
  }
}

class Web implements Device{
}

class MacOS implements Device{

}

class Windows implements Device{

}

class DeviceInfoPlugin extends AppApi{
  Device? device;
  bool convertToMap;

  DeviceInfoPlugin({this.convertToMap = false}){
    device = DeviceProvider.getDevice();
  }

  static DeviceInfoPlatform get _platform {
    return DeviceInfoPlatform.instance;
  }

  @override
  Future<dynamic> getInfo() async {
    switch (device!) {
      case Android():
        return await Android().getInfo(_platform, convertToMap);
      case IOS():
        return IOS().getInfo(_platform, convertToMap);
      case Linux():
        return await Linux().getInfo(_platform, convertToMap);
      case Web():
        break;
      case MacOS():
        break;
      case Windows():
        break;
    }
  }
}
