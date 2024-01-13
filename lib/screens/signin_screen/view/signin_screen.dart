
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/functions/snack_bar.dart';

import '../../bmi_home_screen/view/bmi_home_screen.dart';
import '../auth_cubit/auth_cubit.dart';
import '../auth_cubit/auth_state.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
          )
        );
        return Scaffold(
            appBar: AppBar(
              leading: null,
              title: const Text('Sign In'),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('BMI Calculator',
                        style: TextStyle(
                          fontSize: 30,
                        )),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                      onPressed: () async {
                        context.read<AuthCubit>().signInAnonymously();

                        snackBar(context, 'Signed in with temporary account.');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BMIHomePage(),
                          ),
                        );
                      },
                      child: state is SignInLoadingState
                          ? const Center(child: CircularProgressIndicator())
                          : const Text(
                              'Sign In',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ]),
            ));
      },
    );
  }
}
