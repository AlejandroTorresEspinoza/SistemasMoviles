import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:untitled/classes/splash_page.dart';
import 'package:untitled/helpers/database_user.dart';
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

  String _name = '';
  String _username = '';
  String _institutionalCode = '';
  String _password = '';

  bool isLoginView = true;
  bool _isEmailValid = true;
  bool _isCodeValid = true;

  DatabaseUser dbUser = DatabaseUser();

  void _validateEmail(String email) async {
    bool isAvailable = await dbUser.isEmailAvailable(email);
    setState(() {
      _isEmailValid = isAvailable;
    });
  }

  void _validateCode(String code) async {
    bool isAvailable = await dbUser.isCodeAvailable(code);
    setState(() {
      _isCodeValid = isAvailable;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String salt = "SomeSaltValue";
      String hashedPassword = generatePasswordHash(_password, salt);
      if (isLoginView) {
        bool loginSuccess = await dbUser.loginUser(_username, hashedPassword);
        if (loginSuccess) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Inicio exitoso',
            text: 'Ha iniciado sesión correctamente',
          );

          // Redirección al HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(userName: _username)), // Pasas el _username como argumento a HomePage
          );

        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'Correo o contraseña inválidos.',
          );
        }
      } else {
        bool registrationSuccess = await dbUser.registerUser(_name, _username, _institutionalCode, hashedPassword);
        if (registrationSuccess) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Registro exitoso',
            text: 'Usuario registrado correctamente',
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'Hubo un problema al registrar el usuario. Inténtalo nuevamente.',
          );
        }
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
            onChanged: (value) {
              _username = value;
              _validateEmail(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su correo electrónico';
              } else if (!_isEmailValid) {
                return 'El correo ya está registrado';
              } else if (!value.endsWith("@unmsm.edu.pe")) {
                return 'Por favor ingrese un correo correspondiente al dominio de la San Marcos';
              } else if (!value.contains("@")) {
                return 'Por favor ingrese un correo válido';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Correo',
              alignLabelWithHint: true,
              errorText: !_isEmailValid ? 'El correo ya está registrado' : null,
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            onChanged: (value) {
              _institutionalCode = value;
              _validateCode(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su código institucional';
              } else if (!_isCodeValid) {
                return 'El código ya está registrado';
              } else if (!RegExp(r'^\d{8}$').hasMatch(value)) {
                return 'El código debe contener exactamente 8 dígitos numéricos';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Código Institucional',
              alignLabelWithHint: true,
              errorText: !_isCodeValid ? 'El código ya está registrado' : null,
            ),
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
        child: SingleChildScrollView(
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