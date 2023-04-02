import 'package:device_info_plus/device_info_plugin_redesigned.dart';
import 'package:device_info_plus_platform_interface/model/base_device_info.dart';

/// App API implementation, the class contains all the information
/// to make a call to the device info data and return the correct type
/// useful to UI.

/// This is an abstract class of the API interface
/// useful to implement different type use case,
/// like a MockAPI that can be used
/// to develop demo app, or UI testing
abstract class AppApi {
  Future<dynamic> getInfo();
}
