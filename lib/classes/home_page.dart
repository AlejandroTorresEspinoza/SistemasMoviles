import 'package:flutter/material.dart';
import '../helpers/database_professor.dart';
import 'footer.dart';
import 'list_professor.dart';

class HomePage extends StatefulWidget {
  final String userName;

  HomePage({required this.userName});

  @override
  _HomePageState createState() => _HomePageState();
}

final dbProf = DatabaseProfessor.instance;

class _HomePageState extends State<HomePage> {
  String _searchQuery = "";
  List<Map<String, dynamic>> _searchResults = []; // Lista para almacenar los resultados de la búsqueda

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  _initializeData() async {
    await dbProf.getAllProfessors(); // Iniciamos la bd y obtenemos todos los profesores
  }

  _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchQuery = query;
        _searchResults = [];
      });
    } else {
      List<Map<String, dynamic>> results = await dbProf.searchProfessors(query);
      setState(() {
        _searchQuery = query;
        _searchResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CaliFISI', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Perfil') {
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'Perfil',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Mi perfil'),
                      ],
                    ),
                  ),
                ];
              },
              icon: Icon(Icons.person),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Califica a tus profesores!',
                      style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Evalúa a tus maestros o revisa calificaciones de tus futuros profesores antes de inscribirlos.',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Encuentra a tu profesor de la FISI',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        labelText: "Buscar...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Resultado de búsqueda para: $_searchQuery'),
                    SizedBox(height: 10), // Espacio después de los resultados
                    ..._searchResults.map((professor) => ListTile(
                      title: Text(professor['nombres'] + " " + professor['paterno'] + " " + professor['materno']),
                      subtitle: Text(professor['correo']),
                    )).toList(),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ListProfessorPage()),
                        );
                      },
                      child: Text(
                        'Ver lista de todos los profesores',
                        style: TextStyle(color: Colors.blue, fontSize: 16, decoration: TextDecoration.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
