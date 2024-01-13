import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  signInAnonymously() async {
    emit(SignInLoadingState());
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      emit(SignInSuccessState());
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          emit(SignInErrorState(error: e.toString()));
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  signOut() async {
    emit(SignOutLoadingState());
    try {
      await FirebaseAuth.instance.signOut();
      emit(SignOutSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(SignOutErrorState(error: e.toString()));
    }
  }
}
