import 'package:flutter/material.dart';
import 'package:flutter_rpg/shared/styled_button.dart';
import 'package:flutter_rpg/shared/styled_text.dart';
import 'package:flutter_rpg/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // intro text 
            const Center(child: StyledHeading("Sign in for a new account")),
            const SizedBox(height: 16),

            // email address 
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.kanit( textStyle: Theme.of(context).textTheme.bodyMedium),
              cursorColor: AppColors.textColor,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  label: StyledText('Email'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter an email address.";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // password 
             TextFormField(
              controller: _passwordController,
              obscureText: true,
              style: GoogleFonts.kanit( textStyle: Theme.of(context).textTheme.bodyMedium),
              cursorColor: AppColors.textColor,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  label: StyledText('Password'),
                ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a password.";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // error feedback 
            // submit button 
            StyledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  print("email: " + email + " password: " + password);
                }
              }, 
              child: const StyledHeading("Sign in")
            )
          ],
        )
      )
    );
  }
}