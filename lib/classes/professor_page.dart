import 'package:flutter/material.dart';
import 'footer.dart';

class ProfessorPage extends StatefulWidget {
  final String professorName; // Añadimos el nombre del profesor como un argumento

  ProfessorPage({required this.professorName}); // Modificamos el constructor

  @override
  _ProfessorPageState createState() => _ProfessorPageState();
}

class _ProfessorPageState extends State<ProfessorPage> {
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
                        Icon(Icons.exit_to_app, color: Colors.red),  // Icono de salida
                        SizedBox(width: 8),
                        Text('Cerrar sesión', style: TextStyle(color: Colors.red)),  // Estilo rojo para destacar
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
          // Contenido principal con padding
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,  // Alinea el contenido a la izquierda
                children: [
                  Text(
                    widget.professorName,
                    style: TextStyle(
                        fontSize: 30,  // Tamaño de fuente más grande
                        fontWeight: FontWeight.bold  // Letra en negrita
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Universidad Nacional Mayor de San Marcos',
                    style: TextStyle(fontSize: 18),  // Letra más pequeña que el nombre del profesor
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Ciudad: Lima, Perú',
                    style: TextStyle(fontSize: 18),  // Letra más pequeña que el nombre del profesor
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Facultad: FISI',
                    style: TextStyle(fontSize: 18),  // Letra más pequeña que el nombre del profesor
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Aquí puedes agregar la lógica cuando se presione el botón
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),  // Color celeste del AppBar
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0)  // Aumenta el padding vertical y horizontal
                      ),
                    ),
                    child: Text('Califica a este profesor', style: TextStyle(fontSize: 24)),  // Aumenta el tamaño de la fuente del texto del botón
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16.0), // Agregamos padding para espacio interno
                    color: Color(0xFFF1F2F3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Bloque izquierdo
                        Column(
                          children: [
                            Text(
                              'Calificación General',
                              style: TextStyle(color: Color(0xFF878783)),
                            ),
                            SizedBox(height: 8.0), // Espacio entre texto y número
                            Text(
                              '3.0',
                              style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        // Bloque derecho
                        Column(
                          children: [
                            // Bloque superior derecho
                            Column(
                              children: [
                                Text(
                                  'Lo Recomienda',
                                  style: TextStyle(color: Color(0xFF878783)),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '30%',
                                  style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),  // Espacio entre bloques superiores e inferiores
                            // Bloque inferior derecho
                            Column(
                              children: [
                                Text(
                                  'Nivel de Dificultad',
                                  style: TextStyle(color: Color(0xFF878783)),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '5.2',
                                  style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Color(0xFFF1F2F3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título del container
                        Text(
                          'Calificaciones de Estudiantes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 20), // Espacio entre el título y los bloques

                        // Bloques verticales
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Primer bloque: Calificación
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Calificación',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  // Aquí puedes agregar más contenido para este bloque si es necesario
                                ],
                              ),
                            ),

                            // Segundo bloque: Parámetros
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Parámetros',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  // Aquí puedes agregar más contenido para este bloque si es necesario
                                ],
                              ),
                            ),

                            // Tercer bloque: Comentario (más ancho)
                            Expanded(
                              flex: 2, // Esto hace que el ancho sea el doble que los bloques anteriores
                              child: Column(
                                children: [
                                  Text(
                                    'Comentario',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  // Aquí puedes agregar más contenido para este bloque si es necesario
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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
