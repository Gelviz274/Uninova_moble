import 'package:flutter/material.dart';
import 'package:uninova_mobile/screens/Auth/login_screen.dart';
import 'package:uninova_mobile/screens/Auth/register_screen.dart';
import 'package:uninova_mobile/screens/home/completar_perfil.dart';


class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String completeProfile = '/complete-profile';
  static const String userScreen = '/user-screen';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    completeProfile: (context) => const CompleteProfileScreen(),
  };
}

