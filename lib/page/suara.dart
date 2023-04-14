import 'package:flutter/material.dart';

class SuaraPage extends StatefulWidget {
  const SuaraPage({super.key});

  @override
  State<SuaraPage> createState() => _SuaraPageState();
}

class _SuaraPageState extends State<SuaraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DAFTAR SUARA",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        elevation: 2,
      ),
      body: Container(),
    );
  }
}
