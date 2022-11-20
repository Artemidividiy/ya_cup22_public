import 'package:flutter/material.dart';

import '../../services/connect.dart';
import '../radio/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Connect.buildListViewOfDevices(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () =>
              Connect.services != null && Connect.services!.isNotEmpty
                  ? Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => RadioPage()))
                  : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text("no devices connected"),
                    )),
          label: Text("radio")),
    );
  }
}
