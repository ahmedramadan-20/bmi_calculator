class EntryUpdateState {}

class EntryUpdateInitial extends EntryUpdateState {}

class UpdateBMIFromFirebaseLoadingState extends EntryUpdateState {}

class UpdateBMIFromFirebaseSuccessState extends EntryUpdateState {}

class UpdateBMIFromFirebaseErrorState extends EntryUpdateState {
  final String error;

  UpdateBMIFromFirebaseErrorState({required this.error});
}

class DeleteBMIFromFirebaseLoadingState extends EntryUpdateState {}

class DeleteBMIFromFirebaseSuccessState extends EntryUpdateState {}

class DeleteBMIFromFirebaseErrorState extends EntryUpdateState {
  final String error;

  DeleteBMIFromFirebaseErrorState({required this.error});
}
