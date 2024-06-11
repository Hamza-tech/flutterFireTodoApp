import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/data/firestore.dart';

abstract class AuthenticationDatasource {
  Future<bool> register(String email, String password, String passwordConfirm);
  Future<bool> login(String email, String password);
}

class AuthenticationRemote extends AuthenticationDatasource {
  @override
  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> register(
      String email, String password, String passwordConfirm) async {
    try {
      if (passwordConfirm == password) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.trim(), password: password.trim())
            .then((value) {
          Firestore_Datasource().CreateUser(email);
        });
        return true;
      } else {
        return false; // Passwords do not match
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
