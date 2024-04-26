import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screw/provider/cards_in_the_middle.dart';
import 'package:screw/provider/deck.dart';
import 'package:screw/provider/player.dart';

class YourTurn extends ConsumerWidget {
  const YourTurn({super.key, required this.onScrew, required this.middleCards});
  final middleCards;
  final Function(dynamic) onScrew;
  @override
  Widget build(BuildContext context, ref) {
    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    double devicewidth(BuildContext context) =>
        MediaQuery.of(context).size.width;

    return Row(
      children: [
        CircularCountDownTimer(
          duration: 30,
          controller: CountDownController(),
          width: MediaQuery.of(context).size.width / 8.3,
          height: MediaQuery.of(context).size.height / 10,
          ringColor: const Color.fromARGB(0, 0, 0, 0),
          fillColor: const Color.fromARGB(255, 143, 10, 163),
          backgroundColor: const Color.fromARGB(255, 92, 1, 108),
          strokeWidth: 3.0,
          strokeCap: StrokeCap.round,
          textFormat: CountdownTextFormat.S,
          autoStart: true,
          onComplete: () async {
            if (Navigator.canPop(context)) {
              final drawnCard =
                  ref.read(middleCardsProvider.notifier).getDrawnCard();
              ref.read(middleCardsProvider.notifier).setMiddleCard(drawnCard);
              //if has ability or not
              final cardDeck = ref.read(cardDeckProvider);
              if (cardDeck[drawnCard]![1] == false) {
                ref.read(middleCardsProvider.notifier).incrementplayerTurn();
              } else {
                ref.read(playerProvider.notifier).setAbilityMode(true);
                ref.read(playerProvider.notifier).setSwappingMode(true);
              }

              ///
              Navigator.pop(context);
              await ref.read(middleCardsProvider.notifier).updateOnline();
            } else {
              ref.read(middleCardsProvider.notifier).incrementplayerTurn();
              ref.read(middleCardsProvider.notifier).updateOnline();
            }
          },
          timeFormatterFunction: (defaultFormatterFunction, duration) {
            return Function.apply(defaultFormatterFunction, [duration]);
          },
        ),
        !middleCards['isScrew']
            ? ElevatedButton(
                onPressed: () => onScrew(middleCards),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(deviceHeight(context) / 9.34,
                        devicewidth(context) / 19.2),
                    backgroundColor: const Color.fromRGBO(48, 168, 0, 0.808),
                    shape: const CircleBorder(),
                    elevation: 20),
                child: Center(
                    child: Text(
                  'سكرو',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: devicewidth(context) / 109.71428),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                )))
            : const SizedBox(height: 0, width: 0),
      ],
    );
  }
}

// && !middleCards['isScrew']