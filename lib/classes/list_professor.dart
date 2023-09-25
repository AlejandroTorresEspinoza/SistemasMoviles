import 'package:flutter/material.dart';
import 'footer.dart';
import '../helpers/database_professor.dart';
import 'professor_page.dart';

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
                switch(value) {
                  case 'Perfil':
                  // Código para ir al perfil si es necesario
                    break;
                  case 'Cerrar sesión':
                    Navigator.of(context).pushReplacementNamed('/');
                    break;
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
                  PopupMenuItem<String>(
                    value: 'Cerrar sesión',
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseProfessor.instance.getAllProfessors(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> professors = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Table(
                            border: TableBorder.all(color: Colors.black26, width: 1),
                            columnWidths: {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1),
                            },
                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Apellidos, Nombres', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('# Calificaciones', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Puntuación', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                              ...professors.map((professor) {
                                return TableRow(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProfessorPage(
                                              professorName: '${professor['paterno']} ${professor['materno']}, ${professor['nombres']}',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('${professor['paterno']} ${professor['materno']}, ${professor['nombres']}'),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(''), // Aquí deberías colocar la cantidad de calificaciones, si tienes esa información.
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(''), // Aquí deberías colocar la puntuación del profesor, si tienes esa información.
                                    ),
                                  ],
                                );
                              }).toList(),

                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                Footer(),
              ],
            );
          }
        },
      ),
    );
  }
}