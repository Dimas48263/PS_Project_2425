import 'package:crypto/crypto.dart';
import 'dart:convert';

String encryptPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}