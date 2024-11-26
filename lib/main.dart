import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uninova_mobile/screens/index/home.dart';
import 'package:uninova_mobile/screens/Auth/register_screen.dart';
import 'package:uninova_mobile/screens/home/completar_perfil.dart'; // Si la usas para el perfil
import 'package:uninova_mobile/utils/constants.dart';
import 'package:uninova_mobile/utils/routes.dart';
import 'package:uninova_mobile/screens/Auth/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uninova App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroudColor,
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor: kPrimaryColor,
            fontFamily: 'Mulish'),
        useMaterial3: true,
      ),
      // Definir las rutas aquí
      routes: {
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.register: (context) => RegisterScreen(),
        AppRoutes.completeProfile: (context) => const CompleteProfileScreen(),
        AppRoutes.userScreen: (context) => HomeScreen(), // Ruta para HomeScreen
      },
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  AuthCheck({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // Si el usuario está autenticado, redirige a HomeScreen
          return HomeScreen();
        } else {
          // Si el usuario no está autenticado, redirige a RegisterScreen
          return RegisterScreen();
        }
      },
    );
  }
}
