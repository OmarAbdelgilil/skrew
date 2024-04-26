// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screw/main.dart';
import 'package:screw/provider/cards_in_the_middle.dart';
import 'package:screw/provider/deck.dart';
import 'package:screw/provider/player.dart';
import 'package:screw/screens/result_screen.dart';
import 'package:screw/widgets/drawn_card_options.dart';

class MiddleCards extends ConsumerStatefulWidget {
  const MiddleCards({super.key});

  @override
  ConsumerState<MiddleCards> createState() => _MiddleCardsState();
}

class _MiddleCardsState extends ConsumerState<MiddleCards> {
  int? playerTurn;
  bool _isDrawing = false;
  void _draw(middleCards) async{
    ref.read(middleCardsProvider.notifier).setMiddleCardsMap(middleCards);
    final playerNumber = ref.read(playerProvider.notifier).getPlayerNumber();
    final swappingMode = ref.read(playerProvider.notifier).getSwappingMode();
    if (swappingMode || playerTurn != playerNumber) {
      return;
    }
    setState(() {
      _isDrawing = true;
    });
    final drawnCard = await ref.read(cardDeckProvider.notifier).draw();
    
    if(drawnCard[0] == "end")
    {
      ref.read(middleCardsProvider.notifier).setgameOver(true);
      return ;
    }
    ref.read(middleCardsProvider.notifier).setDrawnCard(drawnCard[0]);
    setState(() {
      _isDrawing = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DrawnCardOptions(drawnCard),
          opaque: false,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
  }

  @override
  Widget build(BuildContext context) {
    //final Map<String, dynamic> middleCards = ref.watch(middleCardsProvider);
    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double deviceWidth(BuildContext context) =>
        MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(kCode)
            .doc('middleCards')
            .snapshots(),
        builder: (ctx, snapshot) {
          if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting || snapshot.hasError)
          {
            return const Center(child: CircularProgressIndicator(),);
          }
          final Map<String, dynamic>? middleCards = snapshot.data!.data();

          playerTurn = middleCards!['playerTurn'];
          if (playerTurn == ref.read(playerProvider.notifier).getPlayerNumber() && ref.read(playerProvider.notifier).getIsSrew())
          {
            ref.read(middleCardsProvider.notifier).setgameOver(true);
            return const ResultScreen();
          }
            
          if(middleCards['gameOver'] == true)
          {
            return const ResultScreen();
          }

          return Stack(children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if(playerTurn == ref.read(playerProvider.notifier).getPlayerNumber())
                      {
                        if(ref.read(playerProvider.notifier).getSwappingMode() == false)
                        {
                          ref.read(playerProvider.notifier).setSwappingMode(true);
                          ref.read(playerProvider.notifier).setSwappingMiddleCard(middleCards['middleCard']);
                        }
                        
                      }
                      
                    },
                    child: Image.asset("assets/${middleCards['middleCard']}.png",
                        height: deviceHeight(context) / 4.90909090909,
                        width: deviceWidth(context) / 11.9818181818,
                        fit: BoxFit.fill),
                  ),
                  InkWell(
                    onTap:()=>_isDrawing? null : _draw(middleCards),
                    child: Image.asset("assets/back.png",
                        height: deviceHeight(context) / 4.90909090909,
                        width: deviceWidth(context) / 11.9818181818,
                        fit: BoxFit.fill),
                  ),
                ],
              ),
            ),
          ]);
        });
  }
}
