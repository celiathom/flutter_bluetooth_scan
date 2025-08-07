import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/bluetooth_device_model.dart';
import 'bluetooth_scan_event.dart';
import 'bluetooth_scan_state.dart';
import 'dart:async';
import 'dart:math';

class DemoBluetoothScanBloc extends Bloc<BluetoothScanEvent, BluetoothScanState> {
  Timer? _scanTimer;
  final Map<String, BluetoothDeviceModel> _devices = {};
  final Random _random = Random();

  // Appareils de démonstration
  final List<Map<String, dynamic>> _demoDevices = [
    {
      'name': 'AirPods Pro',
      'id': 'A1:B2:C3:D4:E5:F6',
      'baseRssi': -45,
    },
    {
      'name': 'Galaxy Watch 4',
      'id': 'F6:E5:D4:C3:B2:A1',
      'baseRssi': -62,
    },
    {
      'name': 'iPhone 13',
      'id': '12:34:56:78:90:AB',
      'baseRssi': -55,
    },
    {
      'name': 'Sony WH-1000XM4',
      'id': 'AB:CD:EF:12:34:56',
      'baseRssi': -38,
    },
    {
      'name': 'MacBook Pro',
      'id': '56:78:90:AB:CD:EF',
      'baseRssi': -71,
    },
    {
      'name': 'Appareil inconnu',
      'id': 'XX:XX:XX:XX:XX:XX',
      'baseRssi': -85,
    },
  ];

  DemoBluetoothScanBloc() : super(const BluetoothScanInitial()) {
    on<StartScanEvent>(_onStartScan);
    on<StopScanEvent>(_onStopScan);
    on<ClearDevicesEvent>(_onClearDevices);
    on<CheckBluetoothStateEvent>(_onCheckBluetoothState);

    // Initialiser avec l'état "prêt"
    add(const CheckBluetoothStateEvent());
  }

  void _onCheckBluetoothState(
    CheckBluetoothStateEvent event,
    Emitter<BluetoothScanState> emit,
  ) {
    // Simuler que le Bluetooth est disponible
    emit(const BluetoothScanStopped(
      devices: [],
      bluetoothState: null, // On ignore l'état Bluetooth pour la démo
    ));
  }

  Future<void> _onStartScan(
    StartScanEvent event,
    Emitter<BluetoothScanState> emit,
  ) async {
    try {
      emit(const BluetoothScanLoading());

      // Petit délai pour simuler l'initialisation
      await Future.delayed(const Duration(milliseconds: 500));

      // Démarrer le scan de démonstration
      _startDemoScan(emit);
    } catch (e) {
      emit(BluetoothScanError(
        message: 'Erreur lors du démarrage du scan: $e',
        devices: _devices.values.toList(),
      ));
    }
  }

  void _startDemoScan(Emitter<BluetoothScanState> emit) {
    int deviceIndex = 0;
    
    _scanTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (deviceIndex < _demoDevices.length) {
        // Ajouter un nouvel appareil
        final demoDevice = _demoDevices[deviceIndex];
        final device = BluetoothDeviceModel(
          id: demoDevice['id'],
          name: demoDevice['name'],
          rssi: _simulateRssi(demoDevice['baseRssi']),
          device: null,
          lastSeen: DateTime.now(),
        );
        
        _devices[device.id] = device;
        deviceIndex++;
      } else {
        // Mettre à jour les RSSI des appareils existants
        for (final deviceData in _demoDevices) {
          if (_devices.containsKey(deviceData['id'])) {
            final existingDevice = _devices[deviceData['id']]!;
            _devices[deviceData['id']] = existingDevice.copyWith(
              rssi: _simulateRssi(deviceData['baseRssi']),
              lastSeen: DateTime.now(),
            );
          }
        }
      }

      // Émettre le nouvel état
      if (!isClosed) {
        emit(BluetoothScanScanning(
          devices: _devices.values.toList()
            ..sort((a, b) => b.rssi.compareTo(a.rssi)),
          bluetoothState: null,
        ));
      }

      // Arrêter automatiquement après 30 secondes
      if (timer.tick >= 15) {
        timer.cancel();
        add(const StopScanEvent());
      }
    });

    // Émettre l'état initial de scan
    emit(const BluetoothScanScanning(
      devices: [],
      bluetoothState: null,
    ));
  }

  int _simulateRssi(int baseRssi) {
    // Ajouter une variation aléatoire de ±10 dBm
    return baseRssi + _random.nextInt(21) - 10;
  }

  Future<void> _onStopScan(
    StopScanEvent event,
    Emitter<BluetoothScanState> emit,
  ) async {
    _scanTimer?.cancel();
    
    emit(BluetoothScanStopped(
      devices: _devices.values.toList()
        ..sort((a, b) => b.rssi.compareTo(a.rssi)),
      bluetoothState: null,
    ));
  }

  void _onClearDevices(
    ClearDevicesEvent event,
    Emitter<BluetoothScanState> emit,
  ) {
    _devices.clear();
    
    final currentState = state;
    if (currentState is BluetoothScanScanning) {
      emit(const BluetoothScanScanning(
        devices: [],
        bluetoothState: null,
      ));
    } else if (currentState is BluetoothScanStopped) {
      emit(const BluetoothScanStopped(
        devices: [],
        bluetoothState: null,
      ));
    }
  }

  @override
  Future<void> close() {
    _scanTimer?.cancel();
    return super.close();
  }
}
