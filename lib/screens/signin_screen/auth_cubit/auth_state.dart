class AuthState {}

class AuthInitial extends AuthState {}

// sign in states
class SignInLoadingState extends AuthState {}

class SignInSuccessState extends AuthState {}

class SignInErrorState extends AuthState {
  final String error;

  SignInErrorState({required this.error});
}

//sign out states
class SignOutLoadingState extends AuthState {}

class SignOutSuccessState extends AuthState {}

class SignOutErrorState extends AuthState {
  final String error;

  SignOutErrorState({required this.error});
}
