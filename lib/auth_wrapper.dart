// lib/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'navigation/main_nav_bar.dart'; // Importa el MainNavBar

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionToken = prefs.getString('session_token');

    // Aquí validas el token de Supabase.
    // Si la sesión es válida, is-logged-in es true.
    final session = Supabase.instance.client.auth.currentSession;
    
    if (session != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // Si el usuario ya está logueado, muestra la barra de navegación
    if (_isLoggedIn) {
      return const MainNavBar(); // ¡¡¡CAMBIA ESTA LÍNEA!!!
    } else {
      // Si no, muestra la pantalla de login
      return const LoginScreen();
    }
  }
}