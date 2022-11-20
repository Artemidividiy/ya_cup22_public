import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:radio/app/home/view.dart';
import 'package:radio/services/enums/status_enum.dart';

import '../../services/service_wrapper.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: ServiceWrapper.initServices(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              try {
                bool tmp = true;
                for (var service in ServiceWrapper.statuses.entries.toList()) {
                  if (service.value != ServiceStatus.working) {
                    tmp = false;
                  }
                }
                if (tmp)
                  return Center(
                    child: ElevatedButton(
                      child: const Text("start"),
                      onPressed: () async => await Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(
                              builder: (_) => const HomePage())),
                    ),
                  );
              } catch (e) {
                log("error splashView futureBuilder", error: e);
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("something went wrong😢"),
                      const Icon(Icons.radio),
                    ],
                  ),
                );
              }
            }
            return const Center(
              child: Icon(Icons.radio),
            );
          }),
    );
  }
}
