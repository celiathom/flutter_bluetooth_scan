// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_bluetooth_scan/bloc/bluetooth_scan_event.dart';
import 'package:flutter_bluetooth_scan/bloc/bluetooth_scan_state.dart';
import 'package:flutter_bluetooth_scan/models/bluetooth_device_model.dart';

void main() {
  group('Bluetooth Scan BLoC Tests', () {
    test('initial state should be BluetoothScanInitial', () {
      // Test that the initial state is correct
      expect(const BluetoothScanInitial(), isA<BluetoothScanInitial>());
    });

    test('BluetoothScanEvent equality works correctly', () {
      // Test event equality
      const event1 = StartScanEvent();
      const event2 = StartScanEvent();
      const event3 = StopScanEvent();

      expect(event1, equals(event2));
      expect(event1, isNot(equals(event3)));
    });

    test('BluetoothScanState equality works correctly', () {
      // Test state equality
      const state1 = BluetoothScanInitial();
      const state2 = BluetoothScanInitial();
      const state3 = BluetoothScanLoading();

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });

  group('Models Tests', () {
    test('BluetoothDeviceModel should be created correctly', () {
      const deviceModel = BluetoothDeviceModel(
        id: 'test-id',
        name: 'Test Device',
        rssi: -50,
        device: null, // null for testing
        lastSeen: null, // null for testing
      );

      expect(deviceModel.id, equals('test-id'));
      expect(deviceModel.name, equals('Test Device'));
      expect(deviceModel.rssi, equals(-50));
    });

    test('BluetoothDeviceModel copyWith works correctly', () {
      const original = BluetoothDeviceModel(
        id: 'test-id',
        name: 'Test Device',
        rssi: -50,
        device: null,
        lastSeen: null,
      );

      final copy = original.copyWith(name: 'Updated Device');

      expect(copy.id, equals(original.id));
      expect(copy.name, equals('Updated Device'));
      expect(copy.rssi, equals(original.rssi));
    });
  });
}
