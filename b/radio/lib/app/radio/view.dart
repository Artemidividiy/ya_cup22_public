import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/connect.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({Key? key}) : super(key: key);

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  late String pathToAudio;
  late bool isRecording;
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  AudioPlayer player = AudioPlayer();
  late Timer timer;
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      var sub =
          Connect.services!.first.characteristics.first.value.listen((value) {
        setState(() {
          Connect.readValues[
              Connect.services!.first.characteristics.first.uuid] = value;
        });
      });
      await Connect.services!.first.characteristics.first.read();
      if (Connect.readValues.isNotEmpty) {
        await player.play(BytesSource(Uint8List.fromList(
            Connect.readValues[Connect.readValues.length - 1]!)));
      }
      sub.cancel();
    });
    isRecording = false;
    super.initState();
    initializer();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("press to talk"),
            ElevatedButton(
                onPressed: talk,
                child: isRecording ? Text("Recording") : Text("record")),
            StreamBuilder<RecordingDisposition>(
                stream: recorder.onProgress,
                builder: (context, snapshot) {
                  final duration = snapshot.hasData
                      ? snapshot.data!.duration
                      : Duration.zero;
                  String twoDigits(num val) => val.toString().padLeft(2, '0');
                  final minutes = twoDigits(duration.inMinutes.remainder(60));
                  final seconds = twoDigits(duration.inSeconds.remainder(60));

                  return duration == Duration.zero
                      ? Container()
                      : Text("$minutes:$seconds s");
                })
          ],
        ),
      ),
    );
  }

  talk() async {
    recorder.isRecording ? await stop() : await record();
  }

  void initializer() async {
    final status = await Permission.microphone.request();
    if (status.isDenied) {
      throw 'microphone permission denied';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 50));
  }

  Future record() async {
    setState(() {
      isRecording = true;
    });
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    setState(() {
      isRecording = false;
    });
    final path = await recorder.stopRecorder();
    print(path);
    if (path != null)
      Connect.services!.first.characteristics.first
          .write(File.fromUri(Uri.parse(path)).readAsBytesSync());
    // Connect.devices.forEach((element) {element})
  }
}
