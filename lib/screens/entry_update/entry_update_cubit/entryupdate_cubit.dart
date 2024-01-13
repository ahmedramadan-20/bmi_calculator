import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/bmi_entry_model.dart';
import 'entryupdate_state.dart';

class EntryUpdateCubit extends Cubit<EntryUpdateState> {
  EntryUpdateCubit() : super(EntryUpdateInitial());

  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? newBmiCategory;

  void updateBmiInFirebase(BmiEntryModel updatedEntry) async {
    try {
      emit(UpdateBMIFromFirebaseLoadingState());

      // Calculate the new BMI
      double newBmi = updatedEntry.weight /
          (updatedEntry.height / 100 * updatedEntry.height / 100);

      // Determine the BMI category based on the new BMI value
      newBmiCategory = calculateBmiCategory(newBmi);

      // Update the BMI and BMI category in the updatedEntry
      updatedEntry =
          updatedEntry.copyWith(bmi: newBmi, bmiCategory: newBmiCategory);

      // Query to find the document with the given timestamp
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bmi_entries')
          .where('timestamp', isEqualTo: updatedEntry.timestamp)
          .get();

      // Check if any documents match the query
      if (snapshot.docs.isNotEmpty) {
        // Update the first document found (assuming timestamp is unique)
        await FirebaseFirestore.instance
            .collection('bmi_entries')
            .doc(snapshot.docs[0].id)
            .update(updatedEntry.toMap());

        emit(UpdateBMIFromFirebaseSuccessState());
      } else {
        // Document with the specified timestamp not found
        print('BMI entry not found with timestamp: ${updatedEntry.timestamp}');
        emit(UpdateBMIFromFirebaseErrorState(
            error:
                'BMI entry not found with timestamp: ${updatedEntry.timestamp}'));
      }
    } catch (error) {
      emit(UpdateBMIFromFirebaseErrorState(error: error.toString()));
    }
  }

  void deleteBmiInFirebase(BmiEntryModel entryToDelete) async {
    try {
      emit(DeleteBMIFromFirebaseLoadingState());

      // Query to find the document with the given timestamp
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bmi_entries')
          .where('timestamp', isEqualTo: entryToDelete.timestamp)
          .get();

      // Check if any documents match the query
      if (snapshot.docs.isNotEmpty) {
        // Delete the first document found (assuming timestamp is unique)
        await FirebaseFirestore.instance
            .collection('bmi_entries')
            .doc(snapshot.docs[0].id)
            .delete();

        print('BMI entry deleted from firebase');
        emit(DeleteBMIFromFirebaseSuccessState());
      } else {
        // Document with the specified timestamp not found
        print('BMI entry not found with timestamp: ${entryToDelete.timestamp}');
        emit(DeleteBMIFromFirebaseErrorState(
            error:
                'BMI entry not found with timestamp: ${entryToDelete.timestamp}'));
      }
    } catch (error) {
      emit(DeleteBMIFromFirebaseErrorState(error: error.toString()));
    }
  }

  String calculateBmiCategory(double? bmi) {
    if (bmi == null) {
      return '';
    }
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }
}
