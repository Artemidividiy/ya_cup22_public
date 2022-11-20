import 'dart:developer';

import 'connect.dart';
import 'enums/status_enum.dart';

class ServiceWrapper {
  static Map<Type, ServiceStatus> statuses = {};
  static Future<bool> initServices() async {
    bool target = await Connect.init();
    log("ServiceWrapper.init done");
    return target;
  }

  static changeStatus(
      {required Type type, ServiceStatus status = ServiceStatus.off}) {
    statuses[type] = status;
  }

  static addStatus(Type type, ServiceStatus status) {}
}
