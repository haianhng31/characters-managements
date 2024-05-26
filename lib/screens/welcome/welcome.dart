import 'package:flutter_rpg/screens/welcome/sign_in.dart';
import 'package:flutter_rpg/screens/welcome/sign_up.dart';
import 'package:flutter_rpg/shared/styled_text.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isSignUpForm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle("Start your story here"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const StyledTitle('Welcome.'),
        
              // sign up screen
              if (isSignUpForm) 
                Column(
                  children: [
                    const SignUpForm(),
                    const StyledText("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUpForm = false;
                        });
                      }, 
                      child: const Text("Sign in instead", style: TextStyle(color: Colors.blue))
                    )
                  ],
                ),
              
              if (!isSignUpForm) 
                Column(
                  children: [
                    const SignInForm(),
                    const StyledText("Need an account?"),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUpForm = true;
                        });
                      }, 
                      child: const Text("Create an account", style: TextStyle(color: Colors.blue))
                    )
                  ],
                ),

              // sign in screen
            ]
          )
        ),
      ),
    );
  }
}