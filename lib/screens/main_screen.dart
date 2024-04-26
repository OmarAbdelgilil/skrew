import 'package:flutter/material.dart';
import 'package:screw/widgets/card_con_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screw/widgets/middle_cards.dart';
import 'package:screw/widgets/name_layout.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key,required this.playerNames});
  // ignore: prefer_typing_uninitialized_variables
  final playerNames;
  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

//final cardDeck = ref.watch(cardDeckProvider);
//ref.read(cardDeckProvider.notifier).draw();
class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/base.png"),
              fit: BoxFit.fill,
            ),
          ),
          child:  Stack(children:[NameLayout(playerNames: widget.playerNames),const CardConLayout(),const MiddleCards()])),
    );
  }
}
