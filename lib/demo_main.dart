import 'package:flutter/material.dart';

void main() {
  runApp(const BluetoothScannerDemo());
}

class BluetoothScannerDemo extends StatelessWidget {
  const BluetoothScannerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bluetooth Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DemoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  bool _isScanning = false;
  List<DemoDevice> _devices = [];

  // Appareils de démonstration
  final List<DemoDevice> _demoDevices = [
    DemoDevice(name: 'AirPods Pro', id: 'A1:B2:C3:D4:E5:F6', rssi: -45),
    DemoDevice(name: 'Galaxy Watch', id: 'F6:E5:D4:C3:B2:A1', rssi: -65),
    DemoDevice(name: 'iPhone de Marie', id: '12:34:56:78:90:AB', rssi: -78),
    DemoDevice(name: 'Appareil inconnu', id: 'AB:CD:EF:12:34:56', rssi: -82),
    DemoDevice(name: 'Mi Band 6', id: '56:78:90:AB:CD:EF', rssi: -55),
  ];

  void _toggleScan() {
    setState(() {
      _isScanning = !_isScanning;
      if (_isScanning) {
        _devices.clear();
        _simulateScan();
      }
    });
  }

  void _simulateScan() async {
    if (!_isScanning) return;
    
    // Simuler la découverte progressive d'appareils
    for (int i = 0; i < _demoDevices.length; i++) {
      if (!_isScanning) break;
      
      await Future.delayed(Duration(milliseconds: 800 + (i * 400)));
      if (_isScanning) {
        setState(() {
          _devices.add(_demoDevices[i]);
        });
      }
    }
  }

  void _clearDevices() {
    setState(() {
      _devices.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scanner Bluetooth',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        actions: [
          if (_devices.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all, color: Colors.white),
              onPressed: _clearDevices,
              tooltip: 'Effacer la liste',
            ),
        ],
      ),
      body: Column(
        children: [
          _buildStatusCard(),
          _buildControlButton(),
          Expanded(
            child: _buildDevicesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    if (_isScanning) {
      statusText = 'Scan en cours... ${_devices.length} appareil(s) trouvé(s)';
      statusColor = Colors.green;
      statusIcon = Icons.bluetooth_searching;
    } else if (_devices.isNotEmpty) {
      statusText = 'Scan arrêté - ${_devices.length} appareil(s) trouvé(s)';
      statusColor = Colors.blue;
      statusIcon = Icons.bluetooth;
    } else {
      statusText = 'Prêt à scanner (Mode Démo)';
      statusColor = Colors.grey;
      statusIcon = Icons.bluetooth;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          if (_isScanning)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: _toggleScan,
        icon: Icon(
          _isScanning ? Icons.stop : Icons.bluetooth_searching,
          color: Colors.white,
        ),
        label: Text(
          _isScanning ? 'Arrêter le scan' : 'Démarrer le scan',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isScanning ? Colors.red[600] : Colors.blue[600],
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildDevicesList() {
    if (_devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bluetooth_disabled,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun appareil détecté',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isScanning 
                ? 'Recherche en cours...'
                : 'Démarrez un scan pour rechercher des appareils Bluetooth',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _devices.length,
      itemBuilder: (context, index) {
        return _buildDeviceCard(_devices[index]);
      },
    );
  }

  Widget _buildDeviceCard(DemoDevice device) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          Icons.bluetooth,
          color: _getRssiColor(device.rssi),
          size: 32,
        ),
        title: Text(
          device.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${device.id}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Signal reçu à l\'instant',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getRssiColor(device.rssi).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${device.rssi} dBm',
            style: TextStyle(
              color: _getRssiColor(device.rssi),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Color _getRssiColor(int rssi) {
    if (rssi >= -50) {
      return Colors.green;
    } else if (rssi >= -70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

class DemoDevice {
  final String name;
  final String id;
  final int rssi;

  DemoDevice({
    required this.name,
    required this.id,
    required this.rssi,
  });
}
