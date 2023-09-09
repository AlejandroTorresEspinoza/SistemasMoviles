class User {
  final int? id;
  final String name;
  final String email;
  final String institutionalCode;
  final String password;
  final int active;

  User({this.id, required this.name, required this.email, required this.institutionalCode, required this.password, this.active = 1}); // Le damos un valor por defecto de 1 a la propiedad active
}
