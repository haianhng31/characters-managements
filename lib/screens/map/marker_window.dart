import 'package:flutter/material.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:flutter_rpg/shared/styled_text.dart';

class MarkerWindow extends StatefulWidget {
  const MarkerWindow({
    super.key,
    required this.characterName,
    required this.characterImg,
    required this.date,
    required this.characterIdsAssociated,
    required this.description,
  });

  final String characterName;
  final String characterImg;
  final String date;
  final List<String> characterIdsAssociated;
  final String description;

  @override
  State<MarkerWindow> createState() => _MarkerWindowState();
}

class _MarkerWindowState extends State<MarkerWindow> {
  late final List<String> charactersAssociated;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: 
      [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipOval( child: Image.asset(
                        widget.characterImg,
                        fit: BoxFit.cover,
                        width: 30, 
                        height: 30
                        )
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledHeading(widget.characterName),
                          StyledText(widget.date)
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 1.0),
                  Expanded(child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText(widget.description),
                      ],
                    ),
                    ),
                  ),
                  const SizedBox(height: 1.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: 
                  //     charactersAssociated.map((img) => Padding(
                  //       padding: const EdgeInsets.all(1.0),
                  //       child: ClipOval( child: Image.asset(
                  //         img,
                  //         fit: BoxFit.cover,
                  //         width: 18, 
                  //         height: 18
                  //         )
                  //       ),
                  //     )).toList()
                  // ),
                ],
              ),
            ),
          ),
        ),
        Triangle.isosceles(
          edge: Edge.BOTTOM,
          child: Container(
            color: Colors.white,
            width: 20.0,
            height: 10.0,
          ),
        ),
      ],
    );
  }
}