import 'dart:convert';
import 'package:crypto/crypto.dart';

String generatePasswordHash(String password, String salt) {
  var bytes = utf8.encode(password + salt); // data being hashed
  var digest = sha256.convert(bytes);
  return digest.toString();
}
