import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:screw/main.dart';

class MiddleCardsNotifier extends StateNotifier<Map<String,dynamic>> {
  MiddleCardsNotifier()
      : super({'middleCard' : '1','drawnCard' :'1','numberOfPlayers' : 4,'playerTurn' : 1,'gameOver' : false,'isScrew' :false});
  Future<void> setMiddleCard(chosenCard) async
  {
    Map<String,dynamic> middleCards = state;
    middleCards['middleCard'] = chosenCard;
    state = {...state,...middleCards};
    //await FirebaseFirestore.instance.collection(kCode).doc('middleCards').update(state);
    //print('set middle card $state');
  }
  Future<void> setDrawnCard(drawnCard) async
  {
    Map<String,dynamic> middleCards = state;
    middleCards['drawnCard'] = drawnCard;
    state = {...state,...middleCards};
    //await FirebaseFirestore.instance.collection(kCode).doc('middleCards').update(state);
  }
  String getDrawnCard()
  {
    //print('getDrawnCard $state');
    return state['drawnCard'];
  }
  Future<String> getMiddleCard() async
  {
    final middleCards = await FirebaseFirestore.instance.collection(kCode).doc('middleCards').get().then((value) => value.data() as Map<String, dynamic>);
    //print('getDrawnCard $state');
    //state = {...state,...middleCards};
    return middleCards['middleCard'];
  }
  Future<void> incrementplayerTurn() async
  {
    Map<String,dynamic> middleCards = state;
    //final cardDeckOnline = await FirebaseFirestore.instance.collection(kCode).doc('middleCards').get().then((value) => value.data() as Map<String, dynamic>);

    middleCards['playerTurn'] == state['numberOfPlayers'] ? middleCards['playerTurn'] = 1 : middleCards['playerTurn']++;
    //cardDeckOnline['playerTurn'] == 2 || cardDeckOnline['playerTurn'] == '2' ? middleCards['playerTurn'] = 1 : middleCards['playerTurn'] = 2;
    state = {...state,...middleCards};
    //await FirebaseFirestore.instance.collection(kCode).doc('middleCards').update({'playerTurn':state['playerTurn'],'numberOfPlayers': state['numberOfPlayers']});
  }
  void setMiddleCardsMap(middleCards)
  {
    state = {...state,...middleCards};
  }
  Future<void> setgameOver(bool trueOrFalse) async
  {
    var playerMap = state;
    playerMap['gameOver'] = trueOrFalse;
    await FirebaseFirestore.instance.collection(kCode).doc('middleCards').set(state);
    state = {...state,...playerMap};
    //print('setSwappingMode $state');
  }
  Future<int> getPlayerTurn() async
  {
    final cardDeckOnline = await FirebaseFirestore.instance.collection(kCode).doc('middleCards').get().then((value) => value.data() as Map<String, dynamic>);
    //state = {...state,...cardDeckOnline};
    return cardDeckOnline['playerTurn'];
  }
  void setPlayerTurn(myturn) async
  {
    final cardDeck = state;
    cardDeck['playerTurn'] = myturn;
    state = {...state,...cardDeck};
  }
  Future<void> setIsScrew(bool trueOrFalse) async
  {
    var playerMap = state;
    playerMap['isScrew'] = trueOrFalse;
    //await FirebaseFirestore.instance.collection(kCode).doc('middleCards').set(state);
    state = {...state,...playerMap};
    //print('setSwappingMode $state');
  }
  Future<void> setNumberOfPlayers(int numberOfPlayers) async
  {
    if (numberOfPlayers > 4)
    {
      return ;
    }
    var playerMap = state;
    playerMap['numberOfPlayers'] = numberOfPlayers;
    await FirebaseFirestore.instance.collection(kCode).doc('middleCards').set(state);
    state = {...state,...playerMap};
    //print('setSwappingMode $state');
  }
  Future<int> getNumberOfPlayers() async
  {
    final cardDeckOnline = await FirebaseFirestore.instance.collection(kCode).doc('middleCards').get().then((value) => value.data() as Map<String, dynamic>);
    //state = {...state,...cardDeckOnline};
    return cardDeckOnline['numberOfPlayers'];
  }
  int getNumberOfPlayersOffline()
  {
    return state['numberOfPlayers'];
  }
  Future<void> updateOnline() async
  {
    await FirebaseFirestore.instance.collection(kCode).doc('middleCards').set(state);
  }
}

final middleCardsProvider =
    StateNotifierProvider<MiddleCardsNotifier,Map<String,dynamic>>(
        (ref) => MiddleCardsNotifier());