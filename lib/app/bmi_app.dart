import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/bmi_home_screen/bmi_cubit/bmi_cubit.dart';
import '../screens/entry_update/entry_update_cubit/entryupdate_cubit.dart';
import '../screens/signin_screen/auth_cubit/auth_cubit.dart';
import '../screens/signin_screen/view/signin_screen.dart';

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => BmiCubit(),
        ),
        BlocProvider(
          create: (context) => EntryUpdateCubit(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BMI Calculator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SignInPage(),
      ),
    );
  }
}
