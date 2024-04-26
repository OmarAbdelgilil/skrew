import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:screw/provider/player.dart';

class ScoreLayout extends ConsumerStatefulWidget {
  const ScoreLayout({super.key});

  @override
  ConsumerState<ScoreLayout> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<ScoreLayout> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double deviceWidth(BuildContext context) =>
        MediaQuery.of(context).size.width;
    //final playerData = ref.watch(playerProvider);
    return Stack(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: deviceHeight(context)/86, left: deviceWidth(context)/88),
            child: Text(
              "SS",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: deviceWidth(context)*0.032),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: deviceHeight(context)/86, right: deviceWidth(context)/88),
            child: Text(
              "SS",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: deviceWidth(context)*0.032),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: deviceHeight(context)/8, left: deviceWidth(context)/68.13),//const EdgeInsets.only(top: 100, left: 24),
            child: Text(
              "SS",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: deviceWidth(context)*0.032),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: deviceHeight(context)/8, right:  deviceWidth(context)/68.13),
            child: Text(
              "SS",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: deviceWidth(context)*0.032),
            ),
          ),
        )
      ],
    );
  }
}
