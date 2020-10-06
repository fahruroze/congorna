import 'package:firebase_auth/firebase_auth.dart';
import 'package:congorna/src/models/pejasa.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

// import 'package:rxdart/subjects.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _pejasa = BehaviorSubject<Pejasa>();

  dispose() {
    _pejasa.close();
  }

  Stream<FirebaseUser> get currentUser => _auth.onAuthStateChanged;

  Future<AuthResult> signInWithCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);

  // Future<AuthResult> signUpWithCredential(AuthCredential credential) =>
  //     _auth.signUpWithCredential(credential);
  //     _auth.regis

  Future<void> logOut() => _auth.signOut();

  // logOut() async {
  //   print('LOGOUTTT');

  //   await _auth.signOut();
  //   _user.sink.add(null);
  //   // await _auth.logOut();

  //   // await authService.signOut();
  //   // FirebaseAuth.getInstance().signOut();
  //   // LoginManager.getInstance().logOut();
  // }

  // _user.sink.add(null);
  // _user.sink.add(null);
  // _user = null;

}
