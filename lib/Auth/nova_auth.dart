import 'package:firebase_auth/firebase_auth.dart';

class NovaAuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }
}
