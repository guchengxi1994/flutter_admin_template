// ignore_for_file: avoid_print

import 'dart:io';

import 'package:sm_crypto/sm_crypto.dart';

void main() {
  print("aaaaaa");
  File file = File(r"D:\Jianying_pro_2_9_5_8278_jianyingpro_0.exe");
  print("bbbbbbbb");
  String sm3Encrypt = SM3.encryptBytes(file.readAsBytesSync());
  print(sm3Encrypt);
}
