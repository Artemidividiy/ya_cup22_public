import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:radio/services/connect_btn.dart';

import 'enums/status_enum.dart';
import 'service_wrapper.dart';

class Connect {
  static late FlutterBluePlus flutterBlue;
  static late List<BluetoothDevice> devices;
  static List<BluetoothService>? services;
  static late Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  static Future<bool> init() async {
    ServiceWrapper.addStatus(Connect, ServiceStatus.initializing);
    devices = [];
    flutterBlue = FlutterBluePlus.instance;
    log("Connect inited");
    ServiceWrapper.changeStatus(type: Connect, status: ServiceStatus.working);
    flutterBlue.connectedDevices.asStream().listen((event) {
      for (BluetoothDevice device in devices) {
        addDeviceTolist(device);
      }
    }).onDone(() {
      log("step done");
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (var result in results) {
        addDeviceTolist(result.device);
      }
    }).onDone(() {
      log("step done");
    });
    services = [];
    for (var device in devices) {
      services!.addAll(await device.services.drain());
    }
    flutterBlue.startScan();
    return true;
  }

  static addDeviceTolist(final BluetoothDevice device) {
    if (!devices.contains(device)) {
      devices.add(device);

      log("new device added");
    }
  }

  static Widget buildListViewOfDevices() {
    return StreamBuilder<List<ScanResult>>(
        initialData: [],
        stream: flutterBlue.scanResults,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length == 0)
              return Center(
                child: CircularProgressIndicator(),
              );
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: Row(
                        children: [
                          Column(
                            children: [
                              Text(snapshot.data![index].device.name == ''
                                  ? '(unknown device)'
                                  : snapshot.data![index].device.name),
                              Text(snapshot.data![index].device.id.toString()),
                            ],
                          ),
                          ConnectBtn(device: snapshot.data![index].device)
                        ],
                      )),
                    ));
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
