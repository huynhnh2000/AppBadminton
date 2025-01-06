import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashPassword(String pass){
  final byte = utf8.encode(pass);
  final hashPass = md5.convert(byte);
  return hashPass.toString().toUpperCase();
}