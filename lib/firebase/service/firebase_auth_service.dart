import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

@injectable
class FirebaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future register(String name, String firstname, String email, String password) async {
    try {
      List<String> signInMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);
      bool userExists = signInMethods.isNotEmpty;
      UserCredential credential;
      if (userExists) {
        credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      }
      User user = credential.user!;
      await FirebaseDatabaseService(uid: user.uid).saveUserData(name, firstname, email);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      LocalStorageHelper.saveFirebaseUserIdToLocalStorage(FirebaseAuth.instance.currentUser!.uid);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future updateUserPassword(String password) async {
    try {
      await firebaseAuth.currentUser!.updatePassword(password);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}