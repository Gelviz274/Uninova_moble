import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uninova_mobile/screens/Auth/login_screen.dart';
import 'package:uninova_mobile/utils/constants.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario actual
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inicio',
          style: TextStyle(
            color: Colors.white, // Color del texto
            fontSize: 20, // Tamaño del texto
            fontWeight: FontWeight.bold, // Peso de la fuente
          ),
        ),
        backgroundColor: kPrimaryColor, // Color café (sienna)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) ...[
              Text(
                '¡Bienvenido, ${user.email}!',
                style: TextStyle(fontSize: 24),
              ),
            ] else ...[
              const Text(
                'No has iniciado sesión.',
                style: TextStyle(fontSize: 24),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // Redirigir a la pantalla de inicio de sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Asegúrate de tener esta clase
                );
              },

              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
