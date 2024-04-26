import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import 'package:screw/main.dart';

class CardDeckNotifier extends StateNotifier<Map<String, List<dynamic>>> {
  CardDeckNotifier()
      : super({
          '-1': [1,false],
          '0': [2,false],
          '1': [4,false],
          '2': [4,false],
          '3': [4,false],
          '4': [4,false],
          '5': [4,false],
          '6': [4,false],
          '7': [4,true],
          '8': [4,true],
          '9': [4,true],
          '10': [4,true],
          '20': [4,false],
          '25': [2,false],
          'khodhat': [10,true],
          'dayer': [2,false],
          'basra': [2,true],
        });
  Future<List<dynamic>> draw() async
  {
    var cardDeckOnline = await FirebaseFirestore.instance.collection(kCode).doc('cardDeck').get().then((value) => value.data());
    cardDeckOnline ??= state;
    if(cardDeckOnline.isEmpty || cardDeckOnline == {})
    {
      return ["end"];
    }
    final random = Random();
    final randomNumber = random.nextInt(cardDeckOnline.length);
    final cardDeck = cardDeckOnline;
    final cardName = cardDeck.keys.toList()[randomNumber];
    final hasAbility = cardDeck[cardName][1];
    cardDeck[cardName]![0] = cardDeck[cardName]![0]-1;
    if(cardDeck[cardName]![0] <= 0)
    {
      cardDeck.remove(cardName);
    }
    final isLast = cardDeck.isEmpty? true : false;
    await FirebaseFirestore.instance.collection(kCode).doc('cardDeck').set(cardDeck);
    state = {...state,...cardDeck};
    
    //print('draw() $state');
    return [cardName,isLast,hasAbility];
  }
  Future<List<String>> drawFourCards()
  async {
    List<String> cards = [];
    for (int i=0;i<4;i++)
    {
      cards.add(await draw().then((value) => value[0]));
    }
    return cards;
  }
  void setCardDeck(cardDeck)
  {
    state = {...state,...cardDeck};
  }
}

final cardDeckProvider =
    StateNotifierProvider<CardDeckNotifier, Map<String, List<dynamic>>>(
        (ref) => CardDeckNotifier());
