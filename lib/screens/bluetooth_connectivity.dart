import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:ria_bluetooth_controller/functionalities/bluetooth_manager.dart';

class BluetoothConnectivity extends StatefulWidget {
  const BluetoothConnectivity({Key? key}) : super(key: key);

  @override
  _BluetoothConnectivityState createState() => _BluetoothConnectivityState();
}

class _BluetoothConnectivityState extends State<BluetoothConnectivity> {
  List<BluetoothDevice> _pairedDevices = [];
  final List<BluetoothDevice> _availableDevices = [];
  bool _isDiscovering = false;
  bool? _isBluetoothEnabled;
  BluetoothDevice? _connectingDevice;
  Map<BluetoothDevice, String> _connectionStatus = {};
  IconData _iconData = Icons.bluetooth_disabled_outlined;
  Color _iconColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _checkBluetoothStatus();
    _startDiscovery();
    _getPairedDevices();
  }

  Future<void> _checkBluetoothStatus() async {
    bool? isEnabled = await FlutterBluetoothSerial.instance.isEnabled;
    setState(() {
      _isBluetoothEnabled = isEnabled;
    });
  }

  Future<void> _enableBluetooth() async {
    await FlutterBluetoothSerial.instance.requestEnable();
    _checkBluetoothStatus();
  }

  Future<void> _disableBluetooth() async {
    await FlutterBluetoothSerial.instance.requestDisable();
    _checkBluetoothStatus();
  }

  @override
  void dispose() {
    _cancelDiscovery();
    super.dispose();
  }

  dynamic _startDiscovery() async {
    setState(() {
      _isDiscovering = true;
    });

    FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      // Check if the device is already in the _pairedDevices list
      bool isPairedDevice = _pairedDevices.any((device) => device.address == r.device.address);

      // Check if the device is already in the _availableDevices list
      bool isAvailableDevice = _availableDevices.any((device) => device.address == r.device.address);

      // Add the device to the _availableDevices list only if it's not already paired and not already in the available list
      if (!isPairedDevice && !isAvailableDevice) {
        setState(() {
          _availableDevices.add(r.device);
        });
      }
    }).onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  void _cancelDiscovery() {
    FlutterBluetoothSerial.instance.cancelDiscovery();
  }

  Future<void> _getPairedDevices() async {
    List<BluetoothDevice> devices =
    await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      _pairedDevices = devices;
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    BluetoothManager bluetoothManager = BluetoothManager();

    if (bluetoothManager.isConnected()) {
      // If the device is already connected, disconnect it
      bluetoothManager.closeConnection();
      setState(() {
        _connectionStatus[device] = 'Disconnected';
        _iconData = Icons.bluetooth_disabled_outlined;
      });
      return; // Exit the function to avoid further processing
    }

    // Check if the device is an "Available Device" (not paired yet)
    bool isAvailableDevice = _availableDevices.contains(device);

    setState(() {
      _connectingDevice = device;
      _connectionStatus[device] =
      isAvailableDevice ? 'Pairing...' : 'Connecting...';
    });

    if (isAvailableDevice) {
      // Pair with the device if it is an "Available Device" (not yet paired)
      try {
        await FlutterBluetoothSerial.instance.bondDeviceAtAddress(device.address);
      } catch (e) {
        print('Error pairing with device: $e');
        // Handle pairing error here if needed
        setState(() {
          _connectingDevice = null;
          _connectionStatus[device] = 'Failed';
        });
        return; // Exit the function to avoid further processing
      }
    }

    // Once paired (or for paired devices), connect to the device
    await bluetoothManager.connectToDevice(device);

    if (bluetoothManager.isConnected()) {
      // If connected, update the state to trigger a widget rebuild (refresh)
      setState(() {
        _connectingDevice = null;
        _connectionStatus[device] = 'Connected';
        _iconData = Icons.bluetooth_connected_outlined;
        _iconColor = Color.fromARGB(255, 251, 183, 38);
      });
    } else {
      setState(() {
        _connectingDevice = null;
        _connectionStatus[device] = 'Failed';
      });
    }
  }

  void _sendCommand(String command) {
    BluetoothManager bluetoothManager = BluetoothManager();
    bluetoothManager.sendCommand(command);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Connectivity"),
        centerTitle: true,
        actions: [
          Icon(_iconData, color: _iconColor),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshDevices(),
        child: ListView.builder(
          itemCount: _pairedDevices.length + _availableDevices.length + 3,
          itemBuilder: (context, index) {
            if (index == 0) {
              // Display toggle button for Bluetooth
              return ListTile(
                title: const Text('Bluetooth'),
                trailing: Switch(
                  value: _isBluetoothEnabled ?? false,
                  onChanged: (value) {
                    if (value) {
                      _enableBluetooth();
                    } else {
                      _disableBluetooth();
                    }
                  },
                ),
              );
            } else if (index == 1) {
              // Display "Paired Devices" ListTile
              return const ListTile(
                title: Text('Paired Devices'),
                dense: true,
              );
            } else if (index <= _pairedDevices.length + 1) {
              // Display paired device ListTile
              BluetoothDevice device = _pairedDevices[index - 2];
              bool isConnected = device == _connectingDevice;

              return ListTile(
                leading: const Icon(Icons.devices_other_outlined),
                title: Text(device.name ?? 'Unknown Device'),
                subtitle: isConnected
                    ? const Text('Connecting...')
                    : _connectionStatus.containsKey(device)
                    ? Text(_connectionStatus[device]!)
                    : Text(device.address),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outlined),
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) {
                    //       return BluetoothInfo();
                    //     },
                    //   ),
                    // );
                  },
                ),
                onTap: () => _connectToDevice(device),
              );
            } else if (index == _pairedDevices.length + 2) {
              // Display "Available Devices" ListTile with refresh button
              return ListTile(
                title: const Text('Available Devices'),
                dense: true,
                trailing: _isDiscovering
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
                    : TextButton(
                  onPressed: _refreshDevices,
                  child: const Text('Refresh'),
                ),
              );
            } else {
              // Display available device ListTile
              BluetoothDevice device =
              _availableDevices[index - _pairedDevices.length - 3];

              return ListTile(
                leading: const Icon(Icons.device_hub_outlined),
                title: Text(device.name ?? 'Unknown Device'),
                subtitle: Text(device.address),
                onTap: () => _connectToDevice(device),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _refreshDevices() async {
    setState(() {
      _availableDevices.clear();
    });
    await _startDiscovery();
  }
}
