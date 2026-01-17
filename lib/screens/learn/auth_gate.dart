import 'package:flutter/material.dart';
import '../../services/backend_service.dart';
import '../../services/token_storage.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    try {
      final token = await TokenStorage().getToken();

      if (token == null || token.isEmpty) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final me = await BackendService.getMe();

      if (!mounted) return;

      if (me != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        await TokenStorage().clearToken();
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (_) {
      await TokenStorage().clearToken();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
