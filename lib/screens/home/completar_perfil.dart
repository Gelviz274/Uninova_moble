import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uninova_mobile/screens/index/home.dart';


class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedSemester;
  String? _selectedCareer;
  String? _selectedUniversity;
  bool _isLoading = false;  // Indicador de carga

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Listas de opciones para los campos desplegables
  final List<String> semesters = List.generate(10, (index) => 'Semestre ${index + 1}');
  final List<String> careers = [
    "Administración de Empresas",
    "Arquitectura",
    "Comunicación Social y Periodismo",
    "Contaduría Pública",
    "Derecho",
    "Enfermería",
    "Ingeniería Civil",
    "Ingeniería de Sistemas",
    "Ingeniería Industrial",
    "Medicina",
    "Psicología",
  ];
  final List<String> universities = [
    "Colegio de Estudios Superiores de Administración (CESA)",
    "Escuela Colombiana de Ingeniería Julio Garavito",
    "Fundación Universitaria Konrad Lorenz",
    "Pontificia Universidad Javeriana",
    "Universidad de América",
    "Universidad de Bogotá Jorge Tadeo Lozano",
    "Universidad de La Sabana",
    "Universidad de Los Andes",
    "Universidad Nacional de Colombia",
    "Universidad Santo Tomás",
  ];

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;  // Iniciar indicador de carga
      });

      try {
        String uid = _auth.currentUser!.uid;

        // Actualizar perfil en Firestore
        await _firestore.collection('users').doc(uid).update({
          'name': _nameController.text,
          'username': _usernameController.text,
          'description': _descriptionController.text,
          'semester': _selectedSemester,
          'career': _selectedCareer,
          'university': _selectedUniversity,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil completado con éxito.')),
        );

        // Redirigir a otra pantalla (por ejemplo, la pantalla principal)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),  // Cambia "HomeScreen" por la pantalla que deseas
        );
      } catch (e) {
        print('Error al guardar el perfil: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el perfil.')),
        );
      } finally {
        setState(() {
          _isLoading = false;  // Detener el indicador de carga
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completar Perfil',style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold),),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Por favor, completa tu perfil:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Nombre
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Ionicons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre no puede estar vacío.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Nombre de usuario
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de usuario',
                    prefixIcon: Icon(Ionicons.at),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre de usuario no puede estar vacío.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Descripción
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon: Icon(Ionicons.text),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                // Semestre
                DropdownButtonFormField<String>(
                  value: _selectedSemester,
                  decoration: const InputDecoration(
                    labelText: 'Semestre',
                    prefixIcon: Icon(Ionicons.school),
                  ),
                  items: semesters
                      .map((semester) => DropdownMenuItem(
                    value: semester,
                    child: Text(semester),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSemester = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona un semestre.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Carrera
                DropdownButtonFormField<String>(
                  value: _selectedCareer,
                  decoration: const InputDecoration(
                    labelText: 'Carrera',
                    prefixIcon: Icon(Ionicons.briefcase),
                  ),
                  items: careers
                      .map((career) => DropdownMenuItem(
                    value: career,
                    child: Text(career),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCareer = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona una carrera.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Universidad
                DropdownButtonFormField<String>(
                  value: _selectedUniversity,
                  decoration: const InputDecoration(
                    labelText: 'Universidad',
                    prefixIcon: Icon(Ionicons.school_outline),
                  ),
                  items: universities
                      .map((university) => DropdownMenuItem(
                    value: university,
                    child: Text(university),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUniversity = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecciona una universidad.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Botón para guardar el perfil
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,  // Deshabilitar si está cargando
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      backgroundColor: Colors.brown,
                      shape: const StadiumBorder(),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Guardar Perfil',
                      style: TextStyle(
                        color: Colors.white, // Asegúrate de usar "color" y no "Colors.white" directamente
                      ),
                    )

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
