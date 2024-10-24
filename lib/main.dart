import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa FirebaseAuth
import 'package:uninova_mobile/screens/index/home.dart';
import 'utils/constants.dart';
import 'screens/Auth/login_screen.dart'; // Asegúrate de tener este archivo
import 'screens/Auth/register_screen.dart'; // Asegúrate de tener este archivo
import 'home/user_screen.dart'; // Importa la nueva pantalla

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
        scaffoldBackgroundColor: kBackgroudColor, // Color de fondo
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor: kPrimaryColor,
            fontFamily: 'Fredoka'), // Colores de texto
        useMaterial3: true,
      ),
      home: AuthCheck(), // Cambia la pantalla inicial a AuthCheck
    );
  }
}

class AuthCheck extends StatelessWidget {
  AuthCheck({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(), // Escucha los cambios en el estado de autenticación
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se espera
        } else if (snapshot.hasData) {
          return HomeScreen(); // Usuario autenticado, redirige a la pantalla del usuario
        } else {
          return RegisterScreen(); // Usuario no autenticado, redirige a la pantalla de registro
        }
      },
    );
  }
}
