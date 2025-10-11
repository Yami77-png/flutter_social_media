import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/features/auth/application/auth_status_cubit/auth_status_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const String route = 'splash_page';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthStatusCubit>().checkAuthStatus();
    return BlocListener<AuthStatusCubit, AuthStatusState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          firstTime: (_) => context.goNamed(GetStarted.route),
          authenticated: (_) => context.goNamed(NavWrapperPage.route),
          // authenticated: (_) => context.goNamed(WebRTCTestPage.route),
          unauthenticated: (_) => context.goNamed(GetStarted.route),
        );
      },
      child: Scaffold(backgroundColor: Colors.white, body: SizedBox.shrink()),
    );
  }
}
