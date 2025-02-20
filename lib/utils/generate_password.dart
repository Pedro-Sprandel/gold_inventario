import 'package:gpassword/gpassword.dart';

String generatePassword() {
  GPassword gPassword = GPassword();

  String password = gPassword.generate(passwordLength: 12);

  return password;
}
