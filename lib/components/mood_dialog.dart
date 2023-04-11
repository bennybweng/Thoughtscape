import 'package:flutter/material.dart';

class MoodDialog extends StatelessWidget {
  const MoodDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: SizedBox(
        height: 130,
        width: 330,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                moodButton("neutral", context),
                moodButton("happy1", context),
                moodButton("happy2", context),
                moodButton("love", context),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                moodButton("angry", context),
                moodButton("sad2", context),
                moodButton("sad3", context),
                moodButton("sad4", context),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget moodButton(String mood, BuildContext context){
    return IconButton(onPressed: (){
      Navigator.pop(context, mood);
    }, icon: Image.asset("assets/$mood.png", height: 45, width: 45,),);
  }
}
