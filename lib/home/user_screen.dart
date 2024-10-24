import 'package:flutter/material.dart';
import 'package:uninova_mobile/Utils/constants.dart';
import '../Utils/api_service.dart';
import 'user.dart';

class UserView extends StatefulWidget {
  final String username; // Propiedad final

  // Constructor que acepta un nombre de usuario y un key opcional
  const UserView({Key? key, required this.username}) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late Future<User?> user;

  @override
  void initState() {
    super.initState();
    // Llamamos a la API para obtener un usuario al iniciar el estado
    user = ApiService().fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Usuarios',
          style: TextStyle(
            color: Colors.white, // Color del texto
            fontSize: 20, // Tamaño del texto
            fontWeight: FontWeight.bold, // Peso de la fuente
          ),
        ),
        backgroundColor: kPrimaryColor, // Color café (sienna)
      ),
      body: Center(
        child: FutureBuilder<User?>(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final userData = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250.0, // Ajusta el ancho deseado
                    height: 250.0, // Ajusta el alto deseado
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26, // Color de la sombra
                          blurRadius: 6.0, // Difuminado de la sombra
                          offset: Offset(0, 3), // Desplazamiento de la sombra
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                      child: Image.network(
                        userData.picture,
                        fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
                      ),
                    ),
                  ),
                  Text(userData.name,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(userData.email,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      )),
                  Text(userData.phone,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      )),
                  Text(userData.country,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      )),
                ],
              );
            } else {
              return Text('No user found');
            }
          },
        ),
      ),
    );
  }
}
