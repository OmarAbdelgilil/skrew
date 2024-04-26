import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screw/main.dart';
import 'package:screw/provider/cards_in_the_middle.dart';
import 'package:screw/provider/player.dart';
import 'package:screw/widgets/card_con.dart';
import 'package:screw/widgets/your_turn.dart';

class CardConLayout extends ConsumerStatefulWidget {
  const CardConLayout({super.key});

  @override
  ConsumerState<CardConLayout> createState() => _CardConLayoutState();
}

class _CardConLayoutState extends ConsumerState<CardConLayout> {
  List playersIndexs = [];
  @override
  void initState() {
    super.initState();
    final myTurn = ref.read(playerProvider.notifier).getPlayerNumber();
    final numberOfPlayers =
        ref.read(middleCardsProvider.notifier).getNumberOfPlayersOffline();
    for (int i = 1; i <= 4; i++) {
      if (i != myTurn) {
        if (i > numberOfPlayers) {
          playersIndexs.add(0);
        } else {
          playersIndexs.add(i);
        }
      }
    }
  }

  void _onSrew(middleCards) async {
    ref.read(middleCardsProvider.notifier).setMiddleCardsMap(middleCards);
    ref.read(playerProvider.notifier).setIsSrew(true);
    ref.read(middleCardsProvider.notifier).setIsScrew(true);
    ref.read(middleCardsProvider.notifier).incrementplayerTurn();
    await ref.read(middleCardsProvider.notifier).updateOnline();
    await ref.read(playerProvider.notifier).updateOnline();
  }

  final back = ['back', 'back', 'back', 'back'];
  @override
  Widget build(BuildContext context) {
    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double devicewidth(BuildContext context) =>
        MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(kCode)
          .doc('middleCards')
          .snapshots(),
      builder: (context, snapshot) {
        final player = ref.watch(playerProvider);
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final Map<String, dynamic>? middleCards = snapshot.data!.data();
        final bool isYourTurn =
            middleCards!['playerTurn'] == player['playerNumber'];
        return Padding(
          padding: EdgeInsets.only(
              top: deviceHeight(context) / 3.1285714285714286666666666666667),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CardsC(
                    back,
                    playerTurn: middleCards['playerTurn'],
                    playerNumber: playersIndexs[0],
                  ),
                  const Spacer(),
                  CardsC(
                    back,
                    playerTurn: middleCards['playerTurn'],
                    playerNumber: playersIndexs[1],
                  )
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardsC(
                    player['cards'],
                    playerTurn: middleCards['playerTurn'],
                    playerNumber: player['playerNumber'],
                  ),
                  isYourTurn
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: deviceHeight(context) / 24.90666,
                              left: devicewidth(context) / 61.44),
                          child: YourTurn(
                              onScrew: _onSrew, middleCards: middleCards),
                        )
                      : const SizedBox(height: 0, width: 0),
                  const Spacer(),
                  CardsC(
                    back,
                    playerTurn: middleCards['playerTurn'],
                    playerNumber: playersIndexs[2],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
