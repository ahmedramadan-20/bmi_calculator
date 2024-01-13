 import '../../../models/bmi_entry_model.dart';

class BmiState {}

class BmiInitial extends BmiState {}

 // calculate Bmi
class BmiLoadingState extends BmiState {}
class BmiSuccessState extends BmiState {}
class BmiErrorState extends BmiState {
  final String error;

  BmiErrorState({required this.error});

}

// add to firebase state
class AddBMIToFirebaseLoadingState extends BmiState {}
class AddBMIToFirebaseSuccessState extends BmiState {}
class AddBMIToFirebaseErrorState extends BmiState {
  final String error;

  AddBMIToFirebaseErrorState({required this.error});

}

// get bmi from firebase
class GetBMIFromFirebaseLoadingState extends BmiState {}
class GetBMIFromFirebaseSuccessState extends BmiState {
  final List<BmiEntryModel> entries;

  GetBMIFromFirebaseSuccessState({required this.entries});
}
class GetBMIFromFirebaseErrorState extends BmiState {
  final String error;

  GetBMIFromFirebaseErrorState({required this.error});

}




