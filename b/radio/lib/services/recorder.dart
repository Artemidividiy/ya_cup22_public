import 'package:radio/services/enums/status_enum.dart';
import 'package:radio/services/service_wrapper.dart';

class Recorder {
  static Future<void> init() async {
    ServiceWrapper.addStatus(Recorder, ServiceStatus.initializing);
    ServiceWrapper.addStatus(Recorder, ServiceStatus.working);
  }

  static Future<void> recordAudio() async {
    
  }
}
