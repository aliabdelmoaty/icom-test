import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/cubit/test_cubit.dart';
import 'package:test/pages/test_all_api.dart';
import 'package:test/widgets/common_widgets.dart';
import 'package:test/core/validators.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController loginController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<TestCubit, TestState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const TestAllApi(),
                  ),
                );
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.watch<TestCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: loginController,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    keyboardType: TextInputType.text,
                    validator: Validators.validateLogin,
                    decoration: const InputDecoration(
                      labelText: 'Login',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: Validators.validatePassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          cubit.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: cubit.togglePasswordVisibility,
                      ),
                      labelText: 'Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    obscureText: state is PasswordVisibilityToggled
                        ? !state.isVisible
                        : !cubit.isPasswordVisible,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Login',
                    isLoading: state is LoginLoading,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit.login(
                          loginController.text,
                          passwordController.text,
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
