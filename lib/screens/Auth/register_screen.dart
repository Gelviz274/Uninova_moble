import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uninova_mobile/home/user_screen.dart'; // Asegúrate de tener esta pantalla para la navegación
import 'package:uninova_mobile/utils/constants.dart';
import 'login_screen.dart';
// Importa tu pantalla de inicio de sesión

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formRegisterKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de FirebaseAuth

  Widget registerButton(String title, GlobalKey<FormState> formKey, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              try {
                // Registrar el usuario
                UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                );

                // Navegar a la pantalla del usuario
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserView(username: _emailController.text), // Cambia esto según tu lógica
                  ),
                );
              } catch (e) {
                // Manejo de errores
                print('Error al registrar: $e');
              }
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: const StadiumBorder(),
            backgroundColor: kPrimaryColor,
            elevation: 8,
            shadowColor: Colors.black87,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? validateEmail(String? value) {
      String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      RegExp regExp = RegExp(pattern);
      if (value == null || value.isEmpty) {
        return 'Ingresa un correo electrónico';
      } else if (!regExp.hasMatch(value)) {
        return 'Ingresa un correo electrónico válido';
      }
      return null;
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Logo_uninova.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                const Text(
                  '¡Crea tu cuenta!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                    fontSize: 40,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    'Bienvenido a Uninova',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                      fontSize: 22,
                    ),
                  ),
                ),
                Form(
                  key: _formRegisterKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: validateEmail,
                        decoration: InputDecoration(
                          labelText: "Correo electrónico",
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                          hintText: 'example@gmail.com',
                          prefixIcon: const Icon(Ionicons.mail, color: Colors.brown),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.brown, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.brown, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa una contraseña';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                          hintText: 'Password123',
                          prefixIcon: const Icon(Ionicons.lock_closed, color: Colors.brown),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.brown, width: 0.8),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.brown, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      registerButton('Registrar', _formRegisterKey, context),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(), // Navega a la pantalla de inicio de sesión
                            ),
                          );
                        },
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '¿Ya tienes una cuenta?',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 17,

                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox( width: 4,),
                            const Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
