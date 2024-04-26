import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screw/provider/cards_in_the_middle.dart';
import 'package:screw/provider/player.dart';

class DrawnCardOptions extends ConsumerStatefulWidget {
  const DrawnCardOptions(this.drawnCard, {super.key});
  final drawnCard;

  @override
  ConsumerState<DrawnCardOptions> createState() => _DrawnCardOptionsState();
}

class _DrawnCardOptionsState extends ConsumerState<DrawnCardOptions> {
  
  //نزل
  void leaveCard() async{
    ref.read(middleCardsProvider.notifier).setMiddleCard(widget.drawnCard[0]);
    //if has ability or not
    if(widget.drawnCard[2] == false)
    {
      ref.read(middleCardsProvider.notifier).incrementplayerTurn();
      if(widget.drawnCard[1])
      {
        ref.read(middleCardsProvider.notifier).setgameOver(true);
      }
    }
    else{
      ref.read(playerProvider.notifier).setAbilityMode(true);
      ref.read(playerProvider.notifier).setSwappingMode(true);
    }
    ///
    Navigator.pop(context); 
    await ref.read(middleCardsProvider.notifier).updateOnline();
  }

  //بدل
  void changeCard() {
    ref.read(playerProvider.notifier).setSwappingMode(true);
    Navigator.pop(context);
    
  }

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
        child: Column(
          children: [
            Image.asset("assets/${widget.drawnCard[0]}.png",
                height: deviceHeight(context) / 3.90909090909,
                width: deviceWidth(context) / 9.9818181818,
                fit: BoxFit.fill),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: leaveCard,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 75, 2, 87),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 10),
                  child: const Text("نزل"),
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: changeCard,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 77, 2, 90),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 10),
                  child: const Text("بدل"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
