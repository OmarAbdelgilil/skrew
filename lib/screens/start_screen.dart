import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screw/main.dart';
import 'package:screw/provider/cards_in_the_middle.dart';
import 'package:screw/provider/deck.dart';
import 'package:screw/provider/player.dart';
import 'package:screw/screens/lobby_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanoid/nanoid.dart';
import 'package:input_quantity/input_quantity.dart';

class StartScreen extends ConsumerStatefulWidget {
  const StartScreen({super.key});

  @override
  ConsumerState<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen> {
  bool _isLoading = false;
  int _numberOfPlayers = 4;
  int? playerNumber;
  Widget? activeScreen;
  final _codeConroller = TextEditingController();
  final _nameConroller = TextEditingController();
  void showAler1t(BuildContext context, String kCode) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Game Code'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const Text('Your game code is :'),
                    Text(kCode),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future<void> _initializeGame() async {
    setState(() {
      _isLoading = true;
    });
    var code = nanoid(7);
    kCode = code;
    print(kCode);
    if (_nameConroller.text.length < 3 || _nameConroller.text.length > 10) {
      //show error popup
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Input Error'),
                content: const Text('error in name input'),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text('okay'))
                ],
              ));
              return ;
    }
    //showAlert(context, kCode);
    ref.read(middleCardsProvider.notifier).setNumberOfPlayers(_numberOfPlayers);
    ref
        .read(playerProvider.notifier)
        .setCards(await ref.read(cardDeckProvider.notifier).drawFourCards());
    ref.read(playerProvider.notifier).setName(_nameConroller.text);
    await FirebaseFirestore.instance
        .collection(kCode)
        .doc('middleCards')
        .set(ref.read(middleCardsProvider));
    final String drawnCard =
        (await ref.read(cardDeckProvider.notifier).draw())[0];
    ref.read(middleCardsProvider.notifier).setDrawnCard(drawnCard);
    ref.read(middleCardsProvider.notifier).setMiddleCard(drawnCard);
    await ref.read(middleCardsProvider.notifier).updateOnline();
    await ref.read(playerProvider.notifier).updateOnline();

    setState(() {
      _isLoading = false;
      activeScreen = const LobbyScreen();
    });
  }

  Future<void> _onSubmitCode() async {
    setState(() {
      _isLoading = true;
    });
    if (_codeConroller.text.isEmpty || _codeConroller.text.length != 7 || _nameConroller.text.length < 3) {
      //show error popup
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Input Error'),
                content: const Text('something is wrong'),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text('okay'))
                ],
              ));
      return;
    }
    final numberOfDocs = await FirebaseFirestore.instance
        .collection(_codeConroller.text)
        .count()
        .get()
        .then((res) => res.count);
    kCode = _codeConroller.text;
    final numberOfPlayers =
        await ref.read(middleCardsProvider.notifier).getNumberOfPlayers();
    if (numberOfDocs < 3 || numberOfDocs > numberOfPlayers + 2) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Input Error'),
                content: Text(numberOfDocs == 0
                    ? "the code isn't found"
                    : numberOfDocs > 5
                        ? "the room is full"
                        : "something went wrong"),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text('okay'))
                ],
              ));
      return;
    }

    ref.read(playerProvider.notifier).setplayerNumber(numberOfDocs - 1);
    final cardDeck = await FirebaseFirestore.instance
        .collection(kCode)
        .doc('cardDeck')
        .get()
        .then((value) => value.data() as Map<String, dynamic>);
    final middleCards = await FirebaseFirestore.instance
        .collection(kCode)
        .doc('middleCards')
        .get()
        .then((value) => value.data() as Map<String, dynamic>);

    ref.read(cardDeckProvider.notifier).setCardDeck(cardDeck);
    ref.read(middleCardsProvider.notifier).setMiddleCardsMap(middleCards);
    ref
        .read(playerProvider.notifier)
        .setCards(await ref.read(cardDeckProvider.notifier).drawFourCards());
    ref.read(playerProvider.notifier).setName(_nameConroller.text);
    await ref.read(playerProvider.notifier).updateOnline();
    setState(() {
      _isLoading = false;
      activeScreen = const LobbyScreen();
    });
  }

  @override
  void dispose() {
    _codeConroller.dispose();
    _nameConroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: activeScreen ??
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: _isLoading ? null : _initializeGame,
                      child: const Text("createGame")),
                  const SizedBox(
                    width: 14,
                  ),
                  InputQty(
                    maxVal: 4,
                    initVal: 4,
                    minVal: 2,
                    borderShape: BorderShapeBtn.circle,
                    decoration:
                        const QtyDecorationProps(qtyStyle: QtyStyle.btnOnRight),
                    onQtyChanged: (val) {
                      _numberOfPlayers = val;
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      decoration:
                          const InputDecoration(label: Text('enter the code')),
                      controller: _codeConroller,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      maxLength: 10,
                      decoration:
                          const InputDecoration(label: Text('enter the name')),
                      controller: _nameConroller,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _onSubmitCode,
                    child: const Text('submit'),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
