import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screw/main.dart';

class PlayerNotifier extends StateNotifier<Map<String, dynamic>> {
  PlayerNotifier()
      : super({
          'numberOfCards': 4,
          'cards': [],
          'score': 0,
          'swappingMode': false,
          'swappingMiddleCard': '',
          'playerNumber': 1,
          'isScrew': false,
          'abilityMode': false,
          'name': 'default',
          'khodhat': '',
        });
  //updates online inside this method
  String changeCard(oldCardIndex, newCard) {
    var playerMap = state;
    playerMap['score'] -= int.tryParse(playerMap['cards'][oldCardIndex]) ?? 10;
    playerMap['score'] += int.tryParse(newCard) ?? 10;
    final oldCard = playerMap['cards'][oldCardIndex];
    playerMap['cards'][oldCardIndex] = newCard;
    state = {...state, ...playerMap};
    FirebaseFirestore.instance
        .collection(kCode)
        .doc('player${state["playerNumber"]}')
        .set(state);
    //print('changeCard $state');
    return oldCard;
  }

  void setCards(List<dynamic> fourCards) {
    var playerMap = state;
    playerMap['cards'] = fourCards;
    playerMap['score'] = (int.tryParse(fourCards[0]) ?? 10) +
        (int.tryParse(fourCards[1]) ?? 10) +
        (int.tryParse(fourCards[2]) ?? 10) +
        (int.tryParse(fourCards[3]) ?? 10);
    state = {...state, ...playerMap};
    //print('setCard $state');
  }

  bool getSwappingMode() {
    //print('gwtswappingmode $state');
    return state['swappingMode'];
  }

  //updates online inside this method
  void setSwappingMode(bool trueOrFalse) async {
    var playerMap = state;
    playerMap['swappingMode'] = trueOrFalse;
    state = {...state, ...playerMap};
    //await FirebaseFirestore.instance.collection(kCode).doc('player${state["playerNumber"]}').update({'swappingMode' : state['swappingMode']});
    //print('setSwappingMode $state');
  }

  int getPlayerNumber() {
    return state['playerNumber'];
  }

  void setplayerNumber(playerNumber) {
    var playerMap = state;
    playerMap['playerNumber'] = playerNumber;
    state = {...state, ...playerMap};
    //print('setplayerNumber $state');
  }

  bool getIsSrew() {
    //print('gwtswappingmode $state');
    return state['isScrew'];
  }

  void setIsSrew(bool trueOrFalse) {
    var playerMap = state;
    playerMap['isScrew'] = trueOrFalse;
    state = {...state, ...playerMap};
    //print('setSwappingMode $state');
  }

  Future<void> updateOnline() async {
    await FirebaseFirestore.instance
        .collection(kCode)
        .doc('player${state["playerNumber"]}')
        .set(state);
  }

  void setBasara(int index) async {
    var playerMap = state;
    playerMap['score'] -= int.tryParse(playerMap['cards'][index]) ?? 10;
    playerMap['cards'][index] = '0';
    //playerMap['numberOfCards']--;
    state = {...state, ...playerMap};
    //await FirebaseFirestore.instance.collection(kCode).doc('player${state["playerNumber"]}').update({'cards' : playerMap['cards'],'score': playerMap['score']});
  }

  void setSwappingMiddleCard(swappedMiddleCard) async {
    var playerMap = state;
    playerMap['swappingMiddleCard'] = swappedMiddleCard;
    state = {...state, ...playerMap};
  }

  String getSwappingMiddleCard() {
    return state['swappingMiddleCard'];
  }

  bool getAbilityMode() {
    //print('gwtswappingmode $state');
    return state['abilityMode'];
  }

  void setAbilityMode(bool trueOrFalse) {
    var playerMap = state;
    playerMap['abilityMode'] = trueOrFalse;
    state = {...state, ...playerMap};
    //print('setSwappingMode $state');
  }

  void setName(String name) {
    var playerMap = state;
    playerMap['name'] = name;
    state = {...state, ...playerMap};
    //print('setSwappingMode $state');
  }

  String getName() {
    return state['name'];
  }

  void setKhodhat(String cardIndex) {
    var playerMap = state;
    playerMap['khodhat'] = cardIndex;
    state = playerMap;
    //print('setkhodhat $state');
  }

  String getKhodhat() {
    return state['khodhat'];
  }

  void updateCardsFromOnline() async {
    final playerCardsOnline = await FirebaseFirestore.instance
        .collection(kCode)
        .doc('player${state["playerNumber"]}')
        .get()
        .then((value) => value.data()!['cards']);
    final playerCardsOffline = state;
    playerCardsOffline['cards'] = playerCardsOnline;
    state = {...state, ...playerCardsOffline};
  }

  Map<String, dynamic> getst() {
    return state;
  }
}

final playerProvider =
    StateNotifierProvider<PlayerNotifier, Map<String, dynamic>>(
        (ref) => PlayerNotifier());
