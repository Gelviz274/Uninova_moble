import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uninova_mobile/screens/Auth/register_screen.dart';
import 'package:uninova_mobile/utils/routes.dart';
import 'package:uninova_mobile/utils/constants.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<Map<String, dynamic>> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data() ?? {};
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Redirigir al usuario a la pantalla de registro
    Navigator.pushReplacementNamed(context, AppRoutes.register);
  }



  void _onMenuSelected(BuildContext context, String value) {
    switch (value) {
      case 'profile':
      // Navegar a la pantalla de editar perfil
        Navigator.pushNamed(context, '/editProfile'); // Define esta ruta en tu proyecto
        break;
      case 'settings':
      // Navegar a configuración
        Navigator.pushNamed(context, '/settings'); // Define esta ruta en tu proyecto
        break;
      case 'logout':
      // Cerrar sesión
        _logout(context);
        break;
      default:
        break;
    }
  }



  @override
  Widget build(BuildContext context) {
    // Verificar si hay un usuario autenticado
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Si no hay usuario autenticado, redirigir a la pantalla de registro
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/register');
      });
      return const Center(child: CircularProgressIndicator()); // Mientras se redirige
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No se encontraron datos del usuario.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Redirigir a otra pantalla si no hay datos
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: const Text('Completar perfil'),
                  ),
                ],
              ),
            ),
          );
        }

        final userData = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kBackgroudColor,
            elevation: 1,
            title: const Text(
              'Uni-nova',
              style: TextStyle(
                color: Colors.brown,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            leading: Container(),  // Aquí desactivas la flecha de retroceso
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.brown),
                onSelected: (value) => _onMenuSelected(context, value),
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.brown),
                      title: Text('Editar perfil'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings, color: Colors.blue),
                      title: Text('Configuración'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text('Cerrar sesión'),
                    ),
                  ),
                ],
              ),
            ],
          ),


          body: SingleChildScrollView(
            child: Column(
              children: [
                // Sección de información del usuario
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.brown.shade200,
                        child: userData['profilePicture'] != ''
                            ? ClipOval(
                          child: Image.network(
                            userData['profilePicture'],
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ),
                        )
                            : const Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['name'] ?? 'Nombre no disponible',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '@${userData['username'] ?? 'username'}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userData['career'] ?? 'Carrera no disponible',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            userData['university'] ?? 'Universidad no disponible',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Sección de publicaciones
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10, // Aquí podrías usar el número de publicaciones
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.brown.shade200,
                                  child: const Icon(Icons.person, size: 20, color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Usuario $index',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const Text('Hace 2 horas', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Este es un ejemplo de publicación en Uni-nova.',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.thumb_up, color: Colors.brown),
                                      onPressed: () {},
                                    ),
                                    const Text('15'),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.comment, color: Colors.brown),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share, color: Colors.brown),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
