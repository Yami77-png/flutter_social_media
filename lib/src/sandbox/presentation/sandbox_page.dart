import 'package:flutter/material.dart';

class SandboxPage extends StatelessWidget {
  const SandboxPage({super.key});
  static const String route = 'sandbox_page';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Click me"),
      ),
    );
  }
}