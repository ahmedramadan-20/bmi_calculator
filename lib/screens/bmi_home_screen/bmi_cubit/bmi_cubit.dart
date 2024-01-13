import 'package:bmi_calculator/models/bmi_entry_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bmi_state.dart';

class BmiCubit extends Cubit<BmiState> {
  BmiCubit() : super(BmiInitial());

  GlobalKey<FormState> bmiFormKey = GlobalKey();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  double? height;
  double? weight;
  int? age;
  double? bmi;
  String? bmiCategory;

// calculate Bmi
  void calculateBmi({
    required double height,
    required double weight,
  }) {
    try {
      if (height <= 0 || weight <= 0) {
        emit(BmiErrorState(
            error: "Height and weight must be greater than zero."));
        return;
      }

      emit(BmiLoadingState());
      bmi = weight / (height / 100 * height / 100);

      // calculate Bmi Category
      bmiCategory = calculateBmiCategory(bmi);

      emit(BmiSuccessState());
    } catch (e) {
      emit(BmiErrorState(error: e.toString()));
    }
  }

  // calculate Bmi Category
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

  // add bmi to firebase
  void addBmiToFirebase(BmiEntryModel bmiEntry) async {
    if (bmiFormKey.currentState!.validate()) {
      try {
        emit(AddBMIToFirebaseLoadingState());

        // Calculate the BMI category based on the BMI value
        bmiCategory = calculateBmiCategory(bmiEntry.bmi);

        // Update the BMI category in the bmiEntry
        bmiEntry = bmiEntry.copyWith(bmiCategory: bmiCategory);

        await FirebaseFirestore.instance
            .collection('bmi_entries')
            .add(bmiEntry.toMap());

        emit(AddBMIToFirebaseSuccessState());
      } catch (error) {
        emit(AddBMIToFirebaseErrorState(error: error.toString()));
      }
    }
  }

  Stream<List<BmiEntryModel>> getPaginatedBmiEntries(
      int pageSize, DocumentSnapshot? startAfter) {
    try {
      emit(GetBMIFromFirebaseLoadingState());
      Query query = FirebaseFirestore.instance
          .collection('bmi_entries')
          .orderBy(
            'timestamp',
          )
          .limit(pageSize);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      return query
          .snapshots()
          .asyncMap<List<BmiEntryModel>>((querySnapshot) async {
        final entries = querySnapshot.docs.map((doc) {
          return BmiEntryModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        if (startAfter != null) {
          // If fetching more entries, append to the existing list
          final currentState = state;
          if (currentState is GetBMIFromFirebaseSuccessState) {
            entries.insertAll(0, currentState.entries);
          }
        }

        emit(GetBMIFromFirebaseSuccessState(entries: entries));
        return entries;
      });
    } catch (error) {
      emit(GetBMIFromFirebaseErrorState(error: error.toString()));
      return const Stream.empty();
    }
  }


}
