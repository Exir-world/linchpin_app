import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

abstract class DeviceInfo {
  Future<DeviceInfoItems> deviceInfo();
}

@LazySingleton(as: DeviceInfo)
class DeviceInfoImpl extends DeviceInfo {
  @override
  Future<DeviceInfoItems> deviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (kIsWeb) {
      // برای وب، می‌تونی اطلاعات مرورگر رو به جای اندروید بدی یا فیلدهای پیشفرض
      var webInfo = await deviceInfoPlugin.webBrowserInfo;
      return DeviceInfoItems(
        board: 'web',
        brand: webInfo.browserName.toString(),
        device: webInfo.userAgent ?? 'unknown',
        id: 'web-id',
        model: webInfo.appVersion ?? 'unknown',
      );
    }

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return DeviceInfoItems(
        board: androidInfo.board,
        brand: androidInfo.brand,
        device: androidInfo.device,
        id: androidInfo.id,
        model: androidInfo.model,
      );
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return DeviceInfoItems(
        board: 'ios',
        brand: iosInfo.name,
        device: iosInfo.model,
        id: iosInfo.identifierForVendor,
        model: iosInfo.utsname.machine,
      );
    }

    // برای سایر پلتفرم‌ها
    return DeviceInfoItems(
      board: 'unknown',
      brand: 'unknown',
      device: 'unknown',
      id: 'unknown',
      model: 'unknown',
    );
  }
}

class DeviceInfoItems {
  final String? model;
  final String? id;
  final String? brand;
  final String? board;
  final String? device;

  DeviceInfoItems({
    this.model,
    this.id,
    this.brand,
    this.board,
    this.device,
  });
}
