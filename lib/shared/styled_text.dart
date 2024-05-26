import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text, {super.key});

  final String text; // It is declared as final, meaning once text is set, it cannot be changed.

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.kanit(
      textStyle: Theme.of(context).textTheme.bodyMedium
    ));
  }
}

class StyledHeading extends StatelessWidget {
  const StyledHeading(this.text, {super.key});

  final String text; 
  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: GoogleFonts.kanit(
      textStyle: Theme.of(context).textTheme.headlineMedium
    ));
  }
}

class StyledTitle extends StatelessWidget {
  const StyledTitle(this.text, {super.key});

  final String text; 

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: GoogleFonts.kanit(
      textStyle: Theme.of(context).textTheme.titleMedium
    ));
  }
}

class StyledErrorText extends StatelessWidget {
  const StyledErrorText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(
        textStyle: const TextStyle(color: Colors.red),
      )
    );
  }
}