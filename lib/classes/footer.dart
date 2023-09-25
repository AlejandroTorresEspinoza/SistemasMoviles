import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,  // Asegura que el ancho sea el máximo disponible
      color: Color(0xFF171717),
      padding: EdgeInsets.all(16.0),
      child: Text(
        '©2023 FISI',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,  // Centra el texto
      ),
    );
  }
}
