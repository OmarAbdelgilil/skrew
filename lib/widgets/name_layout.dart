import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screw/provider/player.dart';
//import 'package:screw/provider/player.dart';

class NameLayout extends ConsumerStatefulWidget {
  const NameLayout({super.key,required this.playerNames});
  // ignore: prefer_typing_uninitialized_variables
  final playerNames;
  @override
  ConsumerState<NameLayout> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<NameLayout> {
  List playerNames = ['','','',''];
  @override
  void initState() {
    super.initState();
    final myName  = ref.read(playerProvider.notifier).getName();
    widget.playerNames.length == 1? playerNames = [widget.playerNames[0],'',myName,''] : widget.playerNames.length == 2? playerNames = [widget.playerNames[0],widget.playerNames[1],myName,''] : playerNames = [widget.playerNames[0],widget.playerNames[1],myName,widget.playerNames[2]];
  }
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
              playerNames[0],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: deviceWidth(context)*0.022),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: deviceHeight(context)/86, right: deviceWidth(context)/88),
            child: Text(
              playerNames[1],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: deviceWidth(context)*0.022),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: deviceHeight(context)/8, left: deviceWidth(context)/68.13),//const EdgeInsets.only(top: 100, left: 24),
            child: Text(
              playerNames[2],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: deviceWidth(context)*0.022),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: deviceHeight(context)/8, right:  deviceWidth(context)/68.13),
            child: Text(
              playerNames[3],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: deviceWidth(context)*0.022),
            ),
          ),
        )
      ],
    );
  }
}
