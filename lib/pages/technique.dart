import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

Map<String,Map<String,String>> techniques ={
  "Tip 1" : {
    "Step 1": "Select an area where you want to experience change or a different result. (Select a well-defined outcome that you have created for yourself.Refer to well-formed outcomes)",
    "Step 2": "List actions that you can take towards this change.",
    "Step 3": "Write about the pain of not taking action towards these results.",
    "Step 4": "Write about how it will feel like to acheive your goals.",
    "Step 5": "Notice the motivation that you can generate by flipping the pain and pleasure.",
    "Step 6": "What is clear to you now?",
    },
    "Tip 2" : {
    "Step 1": "Recall a memory that's only marginally unpleasant.",
    "Step 2": "Notice the pictures, sounds, and any feelings that the memory brings up.",
    "Step 3": "If you're in the picture, step out of it to become an observer.",
    "Step 4": "Change any sound so that they are softer, or perhaps make people in the picture speak in varied voices. If you hear noises such as screaming or crying, reduce their volume and harshness. If you listen to people saying something unpleasant, have them talk to you in a cartoon voice to mitigate their hurtful words.",
    "Step 5": "Adjust the quality of the picture. Make it smaller,darker,and in black and white; move it far away from you until it's a dot and almost invisible. You may want to imagine sending the image up into the sun and watch it disappear in a solar flare. In this way, you experience yourself destroying the hold the memory previously had on you.",
    },
    "Tip 3" : {
    "Step 1": "Recall a day when you felt delighted.",
    "Step 2": "Notice what you see, hear, and feel when you bring back the memory.",
    "Step 3": "If the memory is a picture, adjust its quality by making it bigger, brighter, and, closer. If you are observing yourself, try stepping into the image to see whether this makes you feel better. Adjusting the qualities of the picture can increase positive emotions.",
    "Step 4": "Take note of any sounds in the memory. Does making them louder, or imagining them hearing either inside or outside your head, increase the positive feelings?",
    "Step 5": "Examine any feelings you have. Where in your body are you experiencing them? Do they have a color, texture, and weight alter these feelings? Adjust these parameters to enhance the feelings.",
    },
};

class TechniquePage extends StatefulWidget {
  final String techniqueName;
  TechniquePage({required this.techniqueName,Key? key}) : super(key: key);

  @override
  TechniquePageState createState() => TechniquePageState();
}

class TechniquePageState extends State<TechniquePage> {
  FlutterTts _flutterTts = FlutterTts();

  Map? _currentVoices;

  @override
  void initState() {
    super.initState();
  }

  void initTTS(){
    _flutterTts.getVoices.then((data) {
      try{
        List<Map> _voices = List<Map>.from(data);
        _voices = _voices.where((_voice) => _voice["name"].contains("en")).toList();
        print(_voices);
        setState(() {
          _currentVoices=_voices.first;
          setVoice(_currentVoices!);
          });
      }
      catch(e){
        print(e);
      }
    }
    );

    
  }

  void setVoice(Map voice){
    _flutterTts.setVoice({"name":voice["name"],"locale":voice["locale"]});
  }

  int step_no=0;

   void nextStep() {
    setState(() {
      if (step_no < techniques[widget.techniqueName]!.length-1) {
        step_no++;
      }
    });
  }

  void previousStep() {
    setState(() {
      if (step_no > 0) {
        step_no--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    String currentStep = techniques[widget.techniqueName]!.keys.toList()[step_no];
    String currentStepDescription = techniques[widget.techniqueName]![currentStep]!;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              currentStep,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                   Container(
                  padding: EdgeInsets.all(15),
                  child:Text(
                    currentStepDescription,
                    style: TextStyle(fontSize: 18),
                  ),
                  width: 500,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
                
                SizedBox(width: 20),
                FloatingActionButton(onPressed: (){
                _flutterTts.speak(currentStepDescription);
                },
              child: const Icon(Icons.speaker_phone),),
                    
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              step_no > 0 ? ElevatedButton(
                onPressed: step_no > 0 ? previousStep : null,
                child: Text('Previous'),
              ):
              
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: step_no < techniques[widget.techniqueName]!.length-1 ? nextStep : null,
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}