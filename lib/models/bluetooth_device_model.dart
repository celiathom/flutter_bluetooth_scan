import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDeviceModel extends Equatable {
  final String id;
  final String name;
  final int rssi;
  final BluetoothDevice? device;
  final DateTime? lastSeen;

  const BluetoothDeviceModel({
    required this.id,
    required this.name,
    required this.rssi,
    required this.device,
    required this.lastSeen,
  });

  factory BluetoothDeviceModel.fromScanResult(ScanResult scanResult) {
    return BluetoothDeviceModel(
      id: scanResult.device.remoteId.str,
      name: scanResult.device.platformName.isNotEmpty
          ? scanResult.device.platformName
          : 'Appareil inconnu',
      rssi: scanResult.rssi,
      device: scanResult.device,
      lastSeen: DateTime.now(),
    );
  }

  BluetoothDeviceModel copyWith({
    String? id,
    String? name,
    int? rssi,
    BluetoothDevice? device,
    DateTime? lastSeen,
  }) {
    return BluetoothDeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rssi: rssi ?? this.rssi,
      device: device ?? this.device,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  List<Object?> get props => [id, name, rssi, lastSeen];
}
