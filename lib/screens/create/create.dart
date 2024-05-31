import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rpg/models/character.dart';
import 'package:flutter_rpg/models/vocation.dart';
import 'package:flutter_rpg/screens/create/vocation_card.dart';
import 'package:flutter_rpg/screens/home/home.dart';
import 'package:flutter_rpg/screens/map/map.dart';
import 'package:flutter_rpg/services/character_store.dart';
import 'package:flutter_rpg/shared/styled_button.dart';
import 'package:flutter_rpg/shared/styled_text.dart';
import 'package:flutter_rpg/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _nameController = TextEditingController();
  final _sloganController = TextEditingController();
  // final _backstoryController = TextEditingController();
  late String _backstory = "";
  final _locationController = TextEditingController();
  final _characteristicController = TextEditingController();
  final _occupationController = TextEditingController();
  final _secretController = TextEditingController();
  bool _isLoading = true;

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
    else if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(),
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _sloganController.dispose();
    // _backstoryController.dispose();
    _locationController.dispose();
    _characteristicController.dispose();
    _occupationController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  // handle vocation selection 
  Vocation selectedVocation = Vocation.junkie;

  void _updateVocation(Vocation vocation) {
    setState(() {
      selectedVocation = vocation;
    });
  }

  // generate backstory 
  Future<void> _handleGenerateBackstory() async {
    OpenAICompletionModel completion = await OpenAI.instance.completion.create(
      model: "gpt-3.5-turbo-instruct",
      prompt: "Generate a creative, out-of-the-box, impressive short backstory for a character named ${_nameController.text}, who lives in ${_locationController.text}, is very ${_characteristicController.text}, works as ${_occupationController.text} and has a secret: ${_secretController.text}. Write in less than 10 sentences. Make it interesting and funny.",
      maxTokens: 200,
      temperature: 0.5,
    );
    setState(() {
      _backstory = completion.choices.first.text;
      _isLoading = false;
    });
  }

  void _generateBackstoryModal() async {
    setState(() {
      _isLoading = true;
    });
    await _handleGenerateBackstory();
    if (!_isLoading) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 350,
            padding: const EdgeInsets.all(30),
            color: AppColors.secondaryColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const StyledHeading("Backstory"),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        StyledText(_backstory),
                        const SizedBox(height: 20),
                        StyledButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const StyledHeading("Save"),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    }
  }

  // submit handler 
  void _handleSubmit() {
    if (_nameController.text.trim().isEmpty) {
      showDialog(
        context: context, 
        builder: (ctx) {
          return AlertDialog(
            title: const StyledHeading("Missing character name"),
            content: const StyledText("Every good character needs a name!"),
            actions: [
              StyledButton(
                onPressed: (){
                  Navigator.pop(ctx);
                }, 
                child: const StyledHeading("Close"))
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
      return;
    }
    if (_sloganController.text.trim().isEmpty) {
      showDialog(
        context: context, 
        builder: (ctx) {
          return AlertDialog(
            title: const StyledHeading("Missing character slogan"),
            content: const StyledText("Every good character needs a catchy slogan..."),
            actions: [
              StyledButton(
                onPressed: (){
                  Navigator.pop(ctx);
                }, 
                child: const StyledHeading("Close"))
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
      return;
    }
    if (_backstory.trim().isEmpty) {
      showDialog(
        context: context, 
        builder: (ctx) {
          return AlertDialog(
            title: const StyledHeading("Haven't generated character backstory"),
            content: const StyledText("The backstory makes the character alive."),
            actions: [
              StyledButton(
                onPressed: (){
                  Navigator.pop(ctx);
                }, 
                child: const StyledHeading("Close"))
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
      return;
    }

    Provider.of<CharacterStore>(context, listen: false).addCharacter(
      Character(
        name: _nameController.text.trim(), 
        slogan: _sloganController.text.trim(), 
        vocation: selectedVocation, 
        backstory: _backstory,
        id: uuid.v4()
    ));

    Navigator.push(context, MaterialPageRoute(
      builder: (ctx) => const Home()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle("Character Creation"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // welcome message
              Center(
                child: Icon(Icons.code, color: AppColors.primaryColor)
              ),
              const Center(
                child: StyledHeading("Welcome new player!"),
              ),
              const Center(
                child: StyledText("Create a name and slogan for your character"),
              ),
              const SizedBox(height: 30,),
          
              // input fields
              TextField(
                controller: _nameController,
                style: GoogleFonts.kanit( textStyle: Theme.of(context).textTheme.bodyMedium),
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_2),
                  label: StyledText('Character name'),
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: _sloganController,
                style: GoogleFonts.kanit( textStyle: Theme.of(context).textTheme.bodyMedium),
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.chat),
                  label: StyledText("Character slogan"),
                ),
              ),
          
              const SizedBox(height: 30),
          
              // select vocation 
              Center(
                child: Icon(Icons.code, color: AppColors.primaryColor)
              ),
              const Center(
                child: StyledHeading("Choose a vocation"),
              ),
              const Center(
                child: StyledText("This determines your available skills"),
              ),
          
              const SizedBox(height: 30,),
          
              // vocation cards
              VocationCard(
                selected: selectedVocation == Vocation.junkie,
                onTap: _updateVocation,
                vocation: Vocation.junkie),
              VocationCard(
                selected: selectedVocation == Vocation.ninja,
                onTap: _updateVocation,
                vocation: Vocation.ninja),
              VocationCard(
                selected: selectedVocation == Vocation.wizard,
                onTap: _updateVocation,
                vocation: Vocation.wizard),
              VocationCard(
                selected: selectedVocation == Vocation.raider,
                onTap: _updateVocation,
                vocation: Vocation.raider),

              const SizedBox(height: 30),
          
              // write backstory 
              Center(
                child: Icon(Icons.code, color: AppColors.primaryColor)
              ),
              const Center(
                child: StyledHeading("Generate your character backstory"),
              ),
              const Center(
                child: StyledText("Tell the world how unique they are."),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _locationController,
                style: GoogleFonts.kanit( textStyle: Theme.of(context).textTheme.bodyMedium),
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_2),
                  label: StyledText('Character location'),
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: _characteristicController,
                style: GoogleFonts.kanit( textStyle: Theme.of(context).textTheme.bodyMedium),
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.chat),
                  label: StyledText("Describe how your character is as a person"),
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: _occupationController,
                style: GoogleFonts.kanit( textStyle: Theme.of(context).textTheme.bodyMedium),
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.chat),
                  label: StyledText("Character occupation"),
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: _secretController,
                style: GoogleFonts.kanit( textStyle: Theme.of(context).textTheme.bodyMedium),
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.chat),
                  label: StyledText("A very important secret..."),
                ),
              ),
              const SizedBox(height: 20,),
              StyledButton(
                onPressed: () {
                  _generateBackstoryModal();
                }, 
                child: const StyledHeading("Generate backstory")
              ),

              const SizedBox(height: 30,),
          
              Center(
                child: Icon(Icons.code, color: AppColors.primaryColor)
              ),
              const Center(
                child: StyledHeading("Good luck!"),
              ),
              const Center(
                child: StyledText("Enjoy the journey..."),
              ),

              const SizedBox(height: 30,),              
          
              Center(
                child: StyledButton(
                  onPressed: _handleSubmit, 
                  child: const StyledHeading("Create Character")
                ),
              )
            ],
          ),
        )
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.secondaryColor,
        items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.draw),
              label: 'Create new',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Location',
            ),
          ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white, 
        onTap: _onItemTapped,
      )
    );
  }
}