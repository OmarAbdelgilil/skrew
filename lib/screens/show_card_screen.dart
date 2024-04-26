import 'package:flutter/material.dart';

class ShowCard extends StatelessWidget {
  const ShowCard(this.card,{super.key});
  final card;
  @override
  Widget build(BuildContext context) {
    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double deviceWidth(BuildContext context) =>
        MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: const Color.fromARGB(70, 0, 0, 0),
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 50),
        child:Image.asset("assets/$card.png",
                height: deviceHeight(context) / 3.90909090909,
                width: deviceWidth(context) / 9.9818181818,
                fit: BoxFit.fill),
        ),
    );
  }
}