import 'package:flutter/material.dart';
import 'package:flutter_rpg/models/character.dart';
import 'package:flutter_rpg/theme.dart';

class Heart extends StatefulWidget {
  const Heart({super.key, required this.character});

  final Character character;

  @override
  State<Heart> createState() => _HeartState();
}

class _HeartState extends State<Heart> with SingleTickerProviderStateMixin {
  // Ticker: tick over every frame 
  // & can notify the animation controller about that 
  // so we can kinda continue the animation 
  late AnimationController _controller;

  // tween (between): the transition between two values 
  // a tween sequence: a list of tweens that can be used together 
  late Animation _sizeAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this // references the class - acting as a ticker provider 
    );

    _sizeAnimation = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween(begin: 25, end: 40), // describes the transition between two values 
        // wait: dictates what % of the overall animation duration should be spent on this single tween item
        weight: 50
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: 40, end: 25), 
        weight: 50
      ),
    ]).animate(_controller);
    // what this does is say: 
    // this animation controller will now be responsible for when and how this animation happens 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return IconButton(
          icon: Icon(Icons.favorite, 
            color: widget.character.isFav ? AppColors.primaryColor : Colors.grey[800],
            size: _sizeAnimation.value
          ),
          onPressed: () {
            _controller.reset();
            _controller.forward();
            widget.character.toggleIsFav();
          },
          );
      }
    );
  }
}