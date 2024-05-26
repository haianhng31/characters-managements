import 'package:flutter/material.dart';
import 'package:flutter_rpg/services/auth_service.dart';
import 'package:flutter_rpg/shared/styled_button.dart';
import 'package:flutter_rpg/shared/styled_text.dart';
import 'package:flutter_rpg/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final TextEditingController _usernameController = TextEditingController();
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
            const Center(child: StyledHeading("Sign up for a new account")),
            const SizedBox(height: 16),

            // username
            // TextFormField(
            //   controller: _usernameController,
            //   keyboardType: TextInputType.text,
            //   style: GoogleFonts.kanit( textStyle: Theme.of(context).textTheme.bodyMedium),
            //   cursorColor: AppColors.textColor,
            //   decoration: const InputDecoration(
            //       prefixIcon: Icon(Icons.person_2),
            //       label: StyledText('Username'),
            //     ),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return "Please enter an username.";
            //     }
            //     return null;
            //   },
            // ),
            // const SizedBox(height: 16),

            // email address 
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.kanit( textStyle: Theme.of(context).textTheme.bodyMedium),
              cursorColor: AppColors.textColor,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  label: StyledText('Email address'),
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
                if (value.length < 8) {
                  return "Password must be at least 8 characters long.";
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
                  // final username = _usernameController.text.trim();
                  final user = await AuthService.signUp(email, password);
                }
              }, 
              child: const StyledHeading("Sign up")
            )
          ],
        )
      )
    );
  }
}