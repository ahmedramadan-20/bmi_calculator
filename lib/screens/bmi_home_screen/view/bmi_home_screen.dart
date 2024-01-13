import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/functions/snack_bar.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../models/bmi_entry_model.dart';
import '../../bmi_entries/bmi_entry_screen.dart';
import '../../signin_screen/auth_cubit/auth_cubit.dart';
import '../../signin_screen/auth_cubit/auth_state.dart';
import '../../signin_screen/view/signin_screen.dart';
import '../bmi_cubit/bmi_cubit.dart';
import '../bmi_cubit/bmi_state.dart';

class BMIHomePage extends StatelessWidget {
  const BMIHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocConsumer<BmiCubit, BmiState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BMIEntryScreen(),
                      ));
                },
                icon: const Icon(Icons.menu),
              )
            ],
            centerTitle: true,
            leadingWidth: width / 5,
            leading: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context).signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              },
            ),
            title: const Text('BMI Calculator'),
          ),
          body: const CustomBMIForm(),
        );
      },
    );
  }
}

class CustomBMIForm extends StatelessWidget {
  const CustomBMIForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bmiCubit = context.read<BmiCubit>();

    return BlocConsumer<BmiCubit, BmiState>(
      listener: (context, state) {
        if (state is BmiSuccessState) {
          // Handle success state, if needed
          print('BMI Calculation Successful');

          print(bmiCubit.bmi);

          // Add the BMI entry to Firebase

          final bmiEntry = BmiEntryModel(
            weight: double.parse(bmiCubit.weightController.text),
            height: double.parse(bmiCubit.heightController.text),
            age: int.parse(bmiCubit.ageController.text),
            bmi: bmiCubit.bmi!,
            timestamp: DateTime.now().millisecondsSinceEpoch,
            bmiCategory: bmiCubit.bmiCategory!,
          );
          snackBar(context, 'Adding BMI Entry to Firebase');
          bmiCubit.addBmiToFirebase(bmiEntry);
          snackBar(context, 'BMI Entry Added to Firebase');
        } else if (state is BmiErrorState) {
          // Handle error state, if needed
          snackBar(context, state.error);
          print('BMI Calculation Error: ${state.error}');
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Form(
            key: bmiCubit.bmiFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please enter your height'),
                CustomTextFormField(
                  labelText: 'Height',
                  controller: bmiCubit.heightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    // You can add more specific validation if needed
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Please enter your weight'),
                CustomTextFormField(
                  labelText: 'Weight',
                  controller: bmiCubit.weightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    // You can add more specific validation if needed
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Please enter your age'),
                CustomTextFormField(
                  onFieldSubmitted: (value) {
                    context.read<BmiCubit>().age = int.parse(value);
                    context.read<BmiCubit>().ageController.text = value;
                  },
                  labelText: 'Age',
                  controller: bmiCubit.ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    // You can add more specific validation if needed
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: state is AddBMIToFirebaseLoadingState
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                          ),
                          onPressed: () {
                            if (bmiCubit.bmiFormKey.currentState!.validate()) {
                              // If the form is valid, proceed with BMI calculation
                              bmiCubit.calculateBmi(
                                height: double.parse(
                                    bmiCubit.heightController.text),
                                weight: double.parse(
                                    bmiCubit.weightController.text),
                              );
                              bmiCubit.calculateBmiCategory(bmiCubit.bmi);
                            }
                          },
                          child: const Text(
                            'Calculate',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
