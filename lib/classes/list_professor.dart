import 'package:flutter/material.dart';
import 'footer.dart';

class ListProfessorPage extends StatefulWidget {
  @override
  _ListProfessorPageState createState() => _ListProfessorPageState();
}

class _ListProfessorPageState extends State<ListProfessorPage> {
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
                // Acciones según el item seleccionado
                if (value == 'Perfil') {
                  // Aquí puedes añadir la funcionalidad para el perfil
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
                  // Puedes agregar más opciones aquí si lo deseas
                ];
              },
              icon: Icon(Icons.person),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Contenido principal con padding
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text('Aquí irá el contenido de la lista de profesores'),
              ),
            ),
          ),

          // Footer sin padding
          Footer(),
        ],
      ),
    );
  }
}
