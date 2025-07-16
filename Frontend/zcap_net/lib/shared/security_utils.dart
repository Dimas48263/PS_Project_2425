
import 'package:bcrypt/bcrypt.dart';

//New@05-07-2025: using same algorithm as API
String hashPassword(String password) {
  return BCrypt.hashpw(password, BCrypt.gensalt());
}

bool verifyPassword(String password, String hashed) {
  return BCrypt.checkpw(password, hashed);
}