import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/bluetooth_device_model.dart';
import 'bluetooth_scan_event.dart';
import 'bluetooth_scan_state.dart';

class BluetoothScanBloc extends Bloc<BluetoothScanEvent, BluetoothScanState> {
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothAdapterState>? _bluetoothStateSubscription;
  final Map<String, BluetoothDeviceModel> _devices = {};
  BluetoothAdapterState _currentBluetoothState = BluetoothAdapterState.unknown;

  BluetoothScanBloc() : super(const BluetoothScanInitial()) {
    on<StartScanEvent>(_onStartScan);
    on<StopScanEvent>(_onStopScan);
    on<DeviceFoundEvent>(_onDeviceFound);
    on<ClearDevicesEvent>(_onClearDevices);
    on<CheckBluetoothStateEvent>(_onCheckBluetoothState);

    // Écouter les changements d'état du Bluetooth
    _bluetoothStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _currentBluetoothState = state;
      if (state != BluetoothAdapterState.on) {
        add(const StopScanEvent());
      }
    });

    // Vérifier l'état initial du Bluetooth
    add(const CheckBluetoothStateEvent());
  }

  Future<void> _onCheckBluetoothState(
    CheckBluetoothStateEvent event,
    Emitter<BluetoothScanState> emit,
  ) async {
    try {
      _currentBluetoothState = await FlutterBluePlus.adapterState.first;
      
      if (_currentBluetoothState != BluetoothAdapterState.on) {
        emit(BluetoothUnavailable(
          message: _getBluetoothStateMessage(_currentBluetoothState),
        ));
      } else {
        emit(BluetoothScanStopped(
          devices: _devices.values.toList(),
          bluetoothState: _currentBluetoothState,
        ));
      }
    } catch (e) {
      emit(BluetoothScanError(
        message: 'Erreur lors de la vérification du Bluetooth: $e',
        devices: _devices.values.toList(),
      ));
    }
  }

  Future<void> _onStartScan(
    StartScanEvent event,
    Emitter<BluetoothScanState> emit,
  ) async {
    try {
      // Vérifier l'état du Bluetooth
      if (_currentBluetoothState != BluetoothAdapterState.on) {
        emit(BluetoothUnavailable(
          message: _getBluetoothStateMessage(_currentBluetoothState),
        ));
        return;
      }

      // Demander les permissions nécessaires
      final permissions = await _requestPermissions();
      if (!permissions) {
        emit(const BluetoothScanError(
          message: 'Permissions Bluetooth requises pour scanner les appareils',
        ));
        return;
      }

      emit(const BluetoothScanLoading());

      // Arrêter le scan en cours si nécessaire
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }

      // Démarrer le scan
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 30),
        androidUsesFineLocation: true,
      );

      // Écouter les résultats du scan
      _scanSubscription?.cancel();
      _scanSubscription = FlutterBluePlus.scanResults.listen(
        (results) {
          for (final result in results) {
            final device = BluetoothDeviceModel.fromScanResult(result);
            _devices[device.id] = device;
          }

          emit(BluetoothScanScanning(
            devices: _devices.values.toList()
              ..sort((a, b) => b.rssi.compareTo(a.rssi)),
            bluetoothState: _currentBluetoothState,
          ));
        },
        onError: (error) {
          emit(BluetoothScanError(
            message: 'Erreur pendant le scan: $error',
            devices: _devices.values.toList(),
          ));
        },
      );

      emit(BluetoothScanScanning(
        devices: _devices.values.toList(),
        bluetoothState: _currentBluetoothState,
      ));
    } catch (e) {
      emit(BluetoothScanError(
        message: 'Erreur lors du démarrage du scan: $e',
        devices: _devices.values.toList(),
      ));
    }
  }

  Future<void> _onStopScan(
    StopScanEvent event,
    Emitter<BluetoothScanState> emit,
  ) async {
    try {
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }
      _scanSubscription?.cancel();

      emit(BluetoothScanStopped(
        devices: _devices.values.toList()
          ..sort((a, b) => b.rssi.compareTo(a.rssi)),
        bluetoothState: _currentBluetoothState,
      ));
    } catch (e) {
      emit(BluetoothScanError(
        message: 'Erreur lors de l\'arrêt du scan: $e',
        devices: _devices.values.toList(),
      ));
    }
  }

  void _onDeviceFound(
    DeviceFoundEvent event,
    Emitter<BluetoothScanState> emit,
  ) {
    // Cette méthode peut être utilisée pour ajouter manuellement des appareils
    // Elle n'est pas strictement nécessaire avec l'implémentation actuelle
  }

  void _onClearDevices(
    ClearDevicesEvent event,
    Emitter<BluetoothScanState> emit,
  ) {
    _devices.clear();
    
    final currentState = state;
    if (currentState is BluetoothScanScanning) {
      emit(BluetoothScanScanning(
        devices: [],
        bluetoothState: _currentBluetoothState,
      ));
    } else if (currentState is BluetoothScanStopped) {
      emit(BluetoothScanStopped(
        devices: [],
        bluetoothState: _currentBluetoothState,
      ));
    }
  }

  Future<bool> _requestPermissions() async {
    // Demander les permissions nécessaires selon la plateforme
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    // Vérifier si toutes les permissions critiques sont accordées
    bool bluetoothGranted = statuses[Permission.bluetooth]?.isGranted ?? false;
    bool locationGranted = statuses[Permission.location]?.isGranted ?? false;
    
    // Sur Android 12+, vérifier les nouvelles permissions
    bool bluetoothScanGranted = statuses[Permission.bluetoothScan]?.isGranted ?? true;
    bool bluetoothConnectGranted = statuses[Permission.bluetoothConnect]?.isGranted ?? true;

    return bluetoothGranted && locationGranted && bluetoothScanGranted && bluetoothConnectGranted;
  }

  String _getBluetoothStateMessage(BluetoothAdapterState state) {
    switch (state) {
      case BluetoothAdapterState.off:
        return 'Bluetooth désactivé. Veuillez l\'activer.';
      case BluetoothAdapterState.unavailable:
        return 'Bluetooth non disponible sur cet appareil.';
      case BluetoothAdapterState.unauthorized:
        return 'Permissions Bluetooth non accordées.';
      case BluetoothAdapterState.turningOn:
        return 'Bluetooth en cours d\'activation...';
      case BluetoothAdapterState.turningOff:
        return 'Bluetooth en cours de désactivation...';
      case BluetoothAdapterState.unknown:
        return 'État du Bluetooth inconnu.';
      default:
        return 'Bluetooth activé.';
    }
  }

  @override
  Future<void> close() {
    _scanSubscription?.cancel();
    _bluetoothStateSubscription?.cancel();
    return super.close();
  }
}
