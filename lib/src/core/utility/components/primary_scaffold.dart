import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_app_bar.dart';

class PrimaryScaffold extends StatelessWidget {
  PrimaryScaffold({super.key, required this.body, this.scaffoldPadding = 20, this.appBarTitle});

  double scaffoldPadding;
  Widget body;
  final String? appBarTitle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle == null ? null : AppAppBar(title: appBarTitle.toString()),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: scaffoldPadding),
          child: body,
        ),
      ),
    );
  }
}
