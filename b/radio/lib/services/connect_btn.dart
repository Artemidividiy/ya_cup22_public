import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'connect.dart';

class ConnectBtn extends StatefulWidget {
  final BluetoothDevice device;
  const ConnectBtn({Key? key, required this.device}) : super(key: key);

  @override
  State<ConnectBtn> createState() => _ConnectBtnState();
}

class _ConnectBtnState extends State<ConnectBtn> {
  late bool isConnecting;
  late bool isConnected;
  @override
  void initState() {
    isConnected = false;
    isConnecting = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isConnected
        ? ElevatedButton(onPressed: null, child: Text("connected"))
        : ElevatedButton(
            onPressed: connect,
            child:
                isConnecting ? CircularProgressIndicator() : Text("connect"));
  }

  void connect() async {
    await Connect.flutterBlue.stopScan();
    setState(() {
      isConnecting = true;
    });
    try {
      await widget.device.connect();
    } catch (e) {
      log("elevated button `connect` error", error: e);
      setState(() {
        isConnecting = false;
      });
    } finally {
      Connect.services = await widget.device.discoverServices();
    }
    setState(() {
      isConnected = true;
    });
  }
}
