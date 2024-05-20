import 'package:flutter/material.dart';
import 'package:flutter_rpg/screens/create/create.dart';
import 'package:flutter_rpg/screens/home/character_card.dart';
import 'package:flutter_rpg/screens/map/map.dart';
// import 'package:flutter_rpg/screens/map/mapBox.dart';
import 'package:flutter_rpg/services/character_store.dart';
import 'package:flutter_rpg/shared/styled_button.dart';
import 'package:flutter_rpg/shared/styled_text.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() { // this runs before the build function 
    Provider.of<CharacterStore>(context, listen: false).fetchCharactersOnce();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle("Your Characters."),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Expanded(
            child: 
              Consumer <CharacterStore> (
                builder:(context, value, child) {
                  return ListView.builder(
                    itemCount: value.characters.length,
                    itemBuilder: (_, index) {
                      return Dismissible( // needs the key 
                        key: ValueKey(value.characters[index].id),
                        onDismissed: (direction) {
                          Provider.of<CharacterStore>(context, listen: false)
                            .removeCharacter(value.characters[index]);
                        },
                        child: CharacterCard(value.characters[index])
                      );
                    },
                  );
                },
              ),
          ),
          
          StyledButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (ctx) => const CreateScreen()
              ));
            }, 
            child: const StyledHeading("Create new")
          ),

          StyledButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (ctx) => const MapPage()
              ));
            }, 
            child: const StyledHeading("See Locations")
          )
        ],
        )
      )
    );
  }
}