import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:untitled/models/user.dart';
import 'package:untitled/helpers/database_helper.dart';
import 'package:untitled/classes/splash_page.dart';
import 'package:untitled/utils/security_utils.dart';
import 'classes/home_page.dart';

void main() => runApp(LoginApp());

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';  // Nuevo campo
  String _username = '';
  String _institutionalCode = '';  // Nuevo campo
  String _password = '';
  bool isLoginView = true;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String salt = "SomeSaltValue";
      String hashedPassword = generatePasswordHash(_password, salt);
      if (isLoginView) {
        // Inicio de sesión
        User? user = await DatabaseHelper.instance.getUser(_username, hashedPassword);
        if (user == null) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            title: 'Error',
            text: 'Correo o contraseña incorrectos.',
          );
          return;
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Éxito',
            text: 'Inicio de sesión exitoso.',
          );

          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userName: user!.name)),
            );
          });
        }

      } else {
        // Registro
        bool emailAlreadyExists = await DatabaseHelper.instance.emailExists(_username);
        bool codeAlreadyExists = await DatabaseHelper.instance.institutionalCodeExists(_institutionalCode);

        if (emailAlreadyExists) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            title: 'Error',
            text: 'El correo ya está registrado.',
          );
          return;
        }

        if (codeAlreadyExists) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            title: 'Error',
            text: 'El código institucional ya está registrado.',
          );
          return;
        }

        User newUser = User(
          name: _name,
          email: _username,
          institutionalCode: _institutionalCode,
          password: hashedPassword,
        );

        await DatabaseHelper.instance.insert(newUser);

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Registro exitoso',
          text: 'Usuario registrado correctamente',
        );

        _formKey.currentState!.reset();
      }
    }
  }

  Widget _loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                onChanged: (value) => _username = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  } else if (!value.endsWith("@unmsm.edu.pe")) {
                    return 'Por favor ingrese un correo correspondiente al dominio de la San Marcos';
                  } else if (!value.contains("@")) {
                    return 'Por favor ingrese un correo válido';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Correo', alignLabelWithHint: true),
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => _password = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  } else if (!RegExp(r'^[a-zA-Z0-9]{6,18}$').hasMatch(value)) {
                    return 'La contraseña debe contener entre 6 a 18 caracteres';
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña', alignLabelWithHint: true),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Ingresar'),
        ),
      ],
    );
  }

  Widget _registerForm() {
    return Container(
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            onChanged: (value) => _name = value,
            validator: (value) =>
            (value == null || value.isEmpty) ? 'Por favor ingrese sus nombres y apellidos' : null,
            decoration: InputDecoration(labelText: 'Nombres y Apellidos', alignLabelWithHint: true),
          ),
          SizedBox(height: 20),
          TextFormField(
            onChanged: (value) => _username = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su correo electrónico';
              } else if (!value.endsWith("@unmsm.edu.pe")) {
                return 'Por favor ingrese un correo correspondiente al dominio de la San Marcos';
              } else if (!value.contains("@")) {
                return 'Por favor ingrese un correo válido';
              }
              return null;
            },
            decoration: InputDecoration(labelText: 'Correo', alignLabelWithHint: true),
          ),
          SizedBox(height: 20),
          TextFormField(
            onChanged: (value) => _institutionalCode = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su código institucional';
              } else if (!RegExp(r'^\d{8}$').hasMatch(value)) {
                return 'El código debe contener exactamente 8 dígitos numéricos';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Código Institucional', alignLabelWithHint: true),
          ),
          SizedBox(height: 20),
          TextFormField(
            onChanged: (value) => _password = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su contraseña';
              } else if (!RegExp(r'^[a-zA-Z0-9]{6,18}$').hasMatch(value)) {
                return 'La contraseña debe contener entre 6 a 18 caracteres';
              }
              return null;
            },
            obscureText: true,
            decoration: InputDecoration(labelText: 'Contraseña', alignLabelWithHint: true),
          ),
          SizedBox(height: 20),
          TextFormField(
            onChanged: (value) {
              // Lógica para verificar si las contraseñas coinciden
            },
            validator: (value) =>
            (value == null || value.isEmpty) ? 'Por favor vuelva a ingresar su contraseña' : (value != _password) ? 'Las contraseñas no coinciden' : null,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Repetir Contraseña', alignLabelWithHint: true),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Registrarse'),
          ),
        ],
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CaliFISI',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 80.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // <-- Añade esto aquí
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 450,
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Image.asset(
                      'assets/portada.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Opiniones que importan, educación que evoluciona: Únete a CaliFISI.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(child: isLoginView ? _loginForm() : _registerForm()),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isLoginView = !isLoginView;
                      });
                    },
                    child: Text(isLoginView ? '¿Nuevo aquí? Registrarse' : '¿Ya tienes cuenta? Ingresar'),
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
