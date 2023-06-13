// ignore_for_file: avoid_print

import 'package:sm_crypto/sm_crypto.dart';

void main() {
  String data = '123456';
  String sm3Encrypt = SM3.encryptString(data);
  print('👇 SM3 Encrypt Data:');
  print(sm3Encrypt.toLowerCase());
}
