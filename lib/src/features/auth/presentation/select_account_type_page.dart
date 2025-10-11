import 'package:flutter/material.dart';

class SelectAccountTypePage extends StatelessWidget {
  const SelectAccountTypePage({super.key});

  static const String route = 'select_account_type';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: Color(0xFFFF675C), shape: BoxShape.circle),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.navigate_before, color: Colors.white, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
