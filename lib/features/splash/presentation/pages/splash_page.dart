import 'package:flutter/material.dart';
import 'package:flutter_auth_backend_app/core/services/secure_storage.dart';
import 'package:flutter_auth_backend_app/core/routes/app_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override void initState() { super.initState(); _checkAuth(); }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final token = await SecureStorageService.getToken();
    final route = token != null ? AppRouter.dashboard : AppRouter.login;
    Navigator.pushReplacementNamed(context, route);
  }

  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}