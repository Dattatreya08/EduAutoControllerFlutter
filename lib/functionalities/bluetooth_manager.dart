import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothManager {
  static BluetoothManager? _instance;

  factory BluetoothManager() {
    _instance ??= BluetoothManager._();
    return _instance!;
  }

  BluetoothManager._();

  BluetoothConnection? _connection;

  Future<void> connectToDevice(BluetoothDevice device) async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
    }

    try {
      _connection = await BluetoothConnection.toAddress(device.address);

      // Do something with the connection, e.g., send/receive data
    } catch (e) {
      print('Connection failed: $e');
    }
  }

  void sendCommand(String command) {
    if (_connection != null) {
      Uint8List bytes = Uint8List.fromList(utf8.encode(command));
      _connection!.output.add(bytes);
      _connection!.output.allSent.then((_) {
        print('Command sent: $command');
      });
    }
  }

  void closeConnection() {
    _connection?.close();
    _connection = null;
  }

  bool isConnected() {
    return _connection != null && _connection!.isConnected;
  }
}
