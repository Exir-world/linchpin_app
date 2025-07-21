import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';

abstract class DeviceInfo {
  Future<DeviceInfoItems> deviceInfo();
}

@LazySingleton(as: DeviceInfo)
class DeviceInfoImpl extends DeviceInfo {
  @override
  Future<DeviceInfoItems> deviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return DeviceInfoItems(
      board: androidInfo.board,
      brand: androidInfo.brand,
      device: androidInfo.device,
      id: androidInfo.id,
      model: androidInfo.model,
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
