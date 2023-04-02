import 'package:device_info_plus/src/model/linux_device_info.dart';
import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';

class LinuxInfo {
  dynamic platform;

  LinuxInfo({required this.platform});

  /// This information does not change from call to call. Cache it.
  LinuxDeviceInfo? _cachedLinuxDeviceInfo;

  Future<dynamic> info(bool convertToMap) async {
    _cachedLinuxDeviceInfo ??= await platform.deviceInfo() as LinuxDeviceInfo;
    return convertToMap ? toMap(_cachedLinuxDeviceInfo!):_cachedLinuxDeviceInfo;
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String,dynamic> toMap(LinuxDeviceInfo data){
    Map<String,dynamic> deviceData = _readLinuxDeviceInfo(data);
    return deviceData;
  }
}
