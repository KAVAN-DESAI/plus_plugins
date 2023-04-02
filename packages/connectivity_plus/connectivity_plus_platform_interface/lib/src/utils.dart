import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';

/// Convert a String to a ConnectivityResult value.
ConnectivityResult parseConnectivityResult(String state) {
  return switch (state) {
    "bluetooth" => ConnectivityResult.bluetooth,
    'wifi' => ConnectivityResult.wifi,
    'ethernet' => ConnectivityResult.ethernet,
    'mobile' => ConnectivityResult.mobile,
    'vpn' => ConnectivityResult.vpn,
    'other' => ConnectivityResult.other,
    'none' => ConnectivityResult.none,
    _ => ConnectivityResult.none
  };
}
