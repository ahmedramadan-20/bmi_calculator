import 'package:bmi_calculator/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/bmi_entry_model.dart';
import '../entry_update_cubit/entryupdate_cubit.dart';

class EntryDetailsPage extends StatelessWidget {
  final BmiEntryModel entry;

  const EntryDetailsPage({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EntryUpdateCubit>();

    cubit.weightController.text = entry.weight.toString();
    cubit.heightController.text = entry.height.toString();
    cubit.ageController.text = entry.age.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Weight:'),
            CustomTextFormField(
                controller: cubit.weightController,
                labelText: 'Weight',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16.0),
            const Text('Height:'),
            CustomTextFormField(
                controller: cubit.heightController,
                labelText: 'Height',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16.0),
            const Text('Age:'),
            CustomTextFormField(
                controller: cubit.ageController,
                labelText: 'Age',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16.0),
            Center(
                child: Text(
                    'BMI Category: ${cubit.newBmiCategory ?? entry.bmiCategory}')),
            const SizedBox(height: 16.0),
            // Display BMI category
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    final updatedEntry = BmiEntryModel(
                      weight: double.parse(cubit.weightController.text),
                      height: double.parse(cubit.heightController.text),
                      age: int.parse(cubit.ageController.text),
                      bmi: entry.bmi,
                      timestamp: entry.timestamp,
                      bmiCategory: cubit.newBmiCategory!,
                    );
                    cubit.updateBmiInFirebase(updatedEntry);
                    // Trigger UI rebuild
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    cubit.deleteBmiInFirebase(entry); // Trigger UI rebuild
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
