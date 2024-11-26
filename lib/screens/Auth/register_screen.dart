import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Para Google Sign-In
import 'login_screen.dart';
import 'package:uninova_mobile/screens/home/completar_perfil.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formRegisterKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de FirebaseAuth

  // FUNCIONES EXISTENTES
  Future<void> _registerUser(BuildContext context) async {
    if (_formRegisterKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String uid = userCredential.user!.uid;

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('users').doc(uid).set({
          'email': _emailController.text.trim(),
          'name': '',
          'username': '',
          'profilePicture': '',  // Eliminado la parte de la imagen
          'description': '',
          'semester': '',
          'career': '',
          'university': '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Redirección a la pantalla de completar perfil
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CompleteProfileScreen(),
          ),
        );
      } catch (e) {
        print('Error al registrar usuario: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  // NUEVAS FUNCIONES AGREGADAS
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Autenticación con Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth!.accessToken,
          idToken: googleAuth.idToken,
        );

        // Iniciar sesión en Firebase con las credenciales de Google
        UserCredential userCredential = await _auth.signInWithCredential(credential);

        // Verificar si el usuario es nuevo
        if (userCredential.additionalUserInfo!.isNewUser) {
          // Guardar detalles adicionales en Firestore
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          await firestore.collection('users').doc(userCredential.user!.uid).set({
            'email': userCredential.user!.email,
            'name': userCredential.user!.displayName ?? '',
            'username': '', // El usuario lo completará más tarde
            'profilePicture': '',  // Eliminado la parte de la imagen
            'description': '',
            'semester': '',
            'career': '',
            'university': '',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        // Navegar a la pantalla de completar perfil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CompleteProfileScreen(),
          ),
        );
      }
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
    }
  }

  Future<void> _signInWithGitHub(BuildContext context) async {
    try {
      // Pedir al usuario que ingrese su token de GitHub (flujo simplificado)
      String githubToken = await _askForGitHubToken(context);

      final credential = GithubAuthProvider.credential(githubToken);

      // Iniciar sesión en Firebase con las credenciales de GitHub
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Verificar si el usuario es nuevo
      if (userCredential.additionalUserInfo!.isNewUser) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName ?? '',
          'username': '',
          'profilePicture': '',  // Eliminado la parte de la imagen
          'description': '',
          'semester': '',
          'career': '',
          'university': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Redirigir a la pantalla de completar perfil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CompleteProfileScreen(),
        ),
      );
    } catch (e) {
      print('Error al iniciar sesión con GitHub: $e');
    }
  }

  Future<String> _askForGitHubToken(BuildContext context) async {
    String token = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController tokenController = TextEditingController();
        return AlertDialog(
          title: const Text('Ingresar Token de GitHub'),
          content: TextField(
            controller: tokenController,
            decoration: const InputDecoration(
              labelText: 'Token',
              hintText: 'Ingresa tu token personal de GitHub',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                token = tokenController.text;
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
    return token;
  }

  // BOTONES PARA GOOGLE Y GITHUB
  Widget socialLoginButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: const StadiumBorder(),
        backgroundColor: color,
        elevation: 5,
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
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
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                    'Bienvenido a Uni-nova',
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
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                          prefixIcon: const Icon(Ionicons.lock_closed, color: Colors.brown),
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
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _registerUser(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.brown,
                          elevation: 5,
                        ),
                        child: const Text(
                          'Registrarme',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      socialLoginButton(
                        'Iniciar sesión con Google',
                        Ionicons.logo_google,
                        Colors.red,
                            () => _signInWithGoogle(context),
                      ),
                      const SizedBox(height: 10),
                      socialLoginButton(
                        'Iniciar sesión con GitHub',
                        Ionicons.logo_github,
                        Colors.black,
                            () => _signInWithGitHub(context),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(color: Colors.black),
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
