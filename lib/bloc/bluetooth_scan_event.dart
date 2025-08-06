import 'package:equatable/equatable.dart';

abstract class BluetoothScanEvent extends Equatable {
  const BluetoothScanEvent();

  @override
  List<Object> get props => [];
}

class StartScanEvent extends BluetoothScanEvent {
  const StartScanEvent();
}

class StopScanEvent extends BluetoothScanEvent {
  const StopScanEvent();
}

class DeviceFoundEvent extends BluetoothScanEvent {
  final String deviceId;
  final String deviceName;
  final int rssi;

  const DeviceFoundEvent({
    required this.deviceId,
    required this.deviceName,
    required this.rssi,
  });

  @override
  List<Object> get props => [deviceId, deviceName, rssi];
}

class ClearDevicesEvent extends BluetoothScanEvent {
  const ClearDevicesEvent();
}

class CheckBluetoothStateEvent extends BluetoothScanEvent {
  const CheckBluetoothStateEvent();
}
