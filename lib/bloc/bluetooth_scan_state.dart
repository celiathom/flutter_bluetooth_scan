import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/bluetooth_device_model.dart';

abstract class BluetoothScanState extends Equatable {
  const BluetoothScanState();

  @override
  List<Object?> get props => [];
}

class BluetoothScanInitial extends BluetoothScanState {
  const BluetoothScanInitial();
}

class BluetoothScanLoading extends BluetoothScanState {
  const BluetoothScanLoading();
}

class BluetoothScanScanning extends BluetoothScanState {
  final List<BluetoothDeviceModel> devices;
  final BluetoothAdapterState? bluetoothState;

  const BluetoothScanScanning({
    required this.devices,
    required this.bluetoothState,
  });

  @override
  List<Object?> get props => [devices, bluetoothState];
}

class BluetoothScanStopped extends BluetoothScanState {
  final List<BluetoothDeviceModel> devices;
  final BluetoothAdapterState? bluetoothState;

  const BluetoothScanStopped({
    required this.devices,
    required this.bluetoothState,
  });

  @override
  List<Object?> get props => [devices, bluetoothState];
}

class BluetoothScanError extends BluetoothScanState {
  final String message;
  final List<BluetoothDeviceModel> devices;

  const BluetoothScanError({
    required this.message,
    this.devices = const [],
  });

  @override
  List<Object?> get props => [message, devices];
}

class BluetoothUnavailable extends BluetoothScanState {
  final String message;

  const BluetoothUnavailable({required this.message});

  @override
  List<Object?> get props => [message];
}
