import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screw/main.dart';
import 'package:screw/provider/cards_in_the_middle.dart';
import 'package:screw/provider/player.dart';
import 'package:screw/screens/show_card_screen.dart';
import 'package:screw/widgets/dirty_flag.dart';

class CardsC extends ConsumerStatefulWidget {
  const CardsC(this.fourCards,{super.key,required this.playerTurn,required this.playerNumber});
  final List<dynamic> fourCards;
  final int playerTurn;
  final int playerNumber;

  @override
  ConsumerState<CardsC> createState() => _CardsCState();
}

class _CardsCState extends ConsumerState<CardsC> {
  bool _isLoading9_10 = false;
  Future<void> _abilities(index,playerNumber,swappingMode,myNumber) async
  {
    final middleCard = await ref.read(middleCardsProvider.notifier).getMiddleCard().then((value) => value);
    ref.read(middleCardsProvider.notifier).setMiddleCard(middleCard);
    ref.read(middleCardsProvider.notifier).setPlayerTurn(myNumber);
    if(middleCard == 'khodhat')
    {
      if(widget.playerNumber == widget.playerTurn)
      {
        ref.read(playerProvider.notifier).setKhodhat(index.toString());
      }else
      {
        final myCardIndex = ref.read(playerProvider.notifier).getKhodhat();
        if(myCardIndex != '' && widget.playerNumber != 0)
        {
          final playerCard = await FirebaseFirestore.instance.collection(kCode).doc('player${widget.playerNumber}').get().then((value) => value.data());
          if(playerCard != null)
          {
            final oldCard = ref.read(playerProvider.notifier).changeCard(int.parse(myCardIndex), playerCard['cards'][index]);
            playerCard['cards'][index] = oldCard;
            await FirebaseFirestore.instance.collection(kCode).doc('player${widget.playerNumber}').update({'cards' : playerCard['cards']});
            ref.read(middleCardsProvider.notifier).incrementplayerTurn();
            ref.read(playerProvider.notifier).setAbilityMode(false);
            ref.read(playerProvider.notifier).setSwappingMode(false);
            await ref.read(middleCardsProvider.notifier).updateOnline();
          }
          return ;
        }
      }
    }
    if(widget.playerNumber == widget.playerTurn)
    {
      if(middleCard == 'basra')
      {
        ref.read(middleCardsProvider.notifier).setMiddleCard(widget.fourCards[index]);
        ref.read(playerProvider.notifier).setBasara(index);
        setState(() 
        {
          basra[index] = true;
        });
        ref.read(middleCardsProvider.notifier).incrementplayerTurn();
        ref.read(playerProvider.notifier).setAbilityMode(false);
        ref.read(playerProvider.notifier).setSwappingMode(false);
        await ref.read(middleCardsProvider.notifier).updateOnline();
        await FirebaseFirestore.instance.collection(kCode).doc('player$playerNumber').update({'cards' : widget.fourCards});
        return ;
      }else if(middleCard == '7' || middleCard == '8')
      {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ShowCard(widget.fourCards[index]),
            opaque: false,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ));
          await Future.delayed(const Duration(milliseconds: 2500),(){
            Navigator.pop(context);
          });
        ref.read(middleCardsProvider.notifier).incrementplayerTurn();
        ref.read(playerProvider.notifier).setAbilityMode(false);
        ref.read(playerProvider.notifier).setSwappingMode(false);
        await ref.read(middleCardsProvider.notifier).updateOnline();
        return ;
      }
    }
    else
    {
      if(middleCard == '9' || middleCard == '10' && widget.playerNumber !=0)
      {
        setState(() {
          _isLoading9_10 = true;
        });
        final playerCard = await FirebaseFirestore.instance.collection(kCode).doc('player${widget.playerNumber}').get().then((value) => value.data());
        if(playerCard == null)
        {
          setState(() {
          _isLoading9_10 = false;
        });
          return ;
        }
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ShowCard(playerCard['cards'][index]),
            opaque: false,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ));
          await Future.delayed(const Duration(milliseconds: 2500),(){
            Navigator.pop(context);
          });
        ref.read(middleCardsProvider.notifier).incrementplayerTurn();
        ref.read(playerProvider.notifier).setAbilityMode(false);
        ref.read(playerProvider.notifier).setSwappingMode(false);
        await ref.read(middleCardsProvider.notifier).updateOnline();
        setState(() {
          _isLoading9_10 = false;
        });
        return ;
      }
    }
    return ;
  }
  void onPressCard(index) async
  {
    final myNumber = ref.read(playerProvider.notifier).getPlayerNumber();
    final swappingMode = ref.read(playerProvider.notifier).getSwappingMode();
    final playerAbilityMode = ref.read(playerProvider.notifier).getAbilityMode();
    if (playerAbilityMode && myNumber == widget.playerTurn)
    {
      await _abilities(index,widget.playerNumber,swappingMode,myNumber);
      return ;
    }
    //basra condition
    if(widget.playerNumber == widget.playerTurn && !swappingMode)
    {
      final middleCard = await ref.read(middleCardsProvider.notifier).getMiddleCard().then((value) => value);
      ref.read(middleCardsProvider.notifier).setMiddleCard(middleCard);
      ref.read(middleCardsProvider.notifier).setPlayerTurn(myNumber);
      if(widget.fourCards[index] != middleCard)
      {
        return ;
      }
      
      if (index == 2)
      {
        setState(() {
          basra[2] = true;
        });
        ref.read(playerProvider.notifier).setBasara(2);
        ref.read(middleCardsProvider.notifier).incrementplayerTurn();
      }
      if (index == 3)
      {
        setState(() {
          basra[3] = true;
        });
        ref.read(playerProvider.notifier).setBasara(3);
        ref.read(middleCardsProvider.notifier).incrementplayerTurn();
      }
      await ref.read(middleCardsProvider.notifier).updateOnline();
      await FirebaseFirestore.instance.collection(kCode).doc('player${widget.playerNumber}').update({'cards' : widget.fourCards});
      return ;
    }
    //////////////////////
    
    if (swappingMode && widget.playerNumber == widget.playerTurn)
    {
      final swappingMiddleCard = ref.read(playerProvider.notifier).getSwappingMiddleCard();
      final cardToChanged = swappingMiddleCard != ''? swappingMiddleCard : ref.read(middleCardsProvider.notifier).getDrawnCard();
      //final cardToChanged = ref.read(middleCardsProvider.notifier).getDrawnCard();
      
      final swappedCard = ref.read(playerProvider.notifier).changeCard(index,cardToChanged);
      ref.read(middleCardsProvider.notifier).setMiddleCard(swappedCard);
      ref.read(playerProvider.notifier).setSwappingMode(false);
      ref.read(playerProvider.notifier).setSwappingMiddleCard('');
      ref.read(middleCardsProvider.notifier).setPlayerTurn(myNumber);
      ref.read(middleCardsProvider.notifier).incrementplayerTurn();
      if(index == 2)
      {
        setState(() {
          flag[2] = true;
        });
      }
      if(index == 3)
      {
        setState(() {
          flag[3] = true;
        });
      }
    await ref.read(middleCardsProvider.notifier).updateOnline();
    await FirebaseFirestore.instance.collection(kCode).doc('player${widget.playerNumber}').update({'cards' : widget.fourCards});
    }
    
    
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  Widget build(BuildContext ctx) {
    final myNumber = ref.read(playerProvider.notifier).getPlayerNumber();
    final widtth =
        MediaQuery.of(ctx).size.width / 19.166137566137566666666666666667;
    final heightSmall =
        MediaQuery.of(ctx).size.height / 7.0441558441558443636363636363636;
    final heightBig =
        MediaQuery.of(ctx).size.height / 5.9604395604395606153846153846154;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(3, 1.8, 1.8, 1.8),
          child: Container(
            width: widtth,
            height: heightSmall,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: const Color.fromARGB(62, 255, 255, 255)),
                child:(basra[0] && widget.playerNumber == myNumber)? SizedBox(height: heightSmall,width: widtth,) : InkWell(onTap: ()=>_isLoading9_10? null : onPressCard(0),enableFeedback: false,child: Image(image: ResizeImage(AssetImage('assets/${flag[0]? "back" : widget.fourCards[0]}.png'), width: widtth.round(), height: heightSmall.round()),),),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(3, 1.8, 1.8, 1.8),
          child: Container(
            width: widtth,
            height: heightSmall,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: const Color.fromARGB(62, 255, 255, 255)),
                child:(basra[1] && widget.playerNumber == myNumber)? SizedBox(height: heightSmall,width: widtth,) : InkWell(onTap: ()=>_isLoading9_10? null : onPressCard(1),enableFeedback: false,child: Image(image: ResizeImage(AssetImage('assets/${flag[1]? "back" : widget.fourCards[1]}.png'), width: widtth.round(), height: heightSmall.round()))),
          ),
        ),
         Padding(
          padding: const EdgeInsets.fromLTRB(3, 1.8, 1.8, 1.8),
          child: Container(
           width: widtth,
            height: heightBig,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: const Color.fromARGB(62, 255, 255, 255)),
                child:(basra[2] && widget.playerNumber == myNumber)? SizedBox(height: heightBig,width: widtth,) : InkWell(onTap: ()=>_isLoading9_10? null : onPressCard(2),enableFeedback: false,child: Image(image: ResizeImage(AssetImage('assets/${flag[2]? "back" : widget.fourCards[2]}.png'), width: widtth.round(), height: heightBig.round()))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(3, 1.8, 1.8, 1.8),
          child: Container(
            width: widtth,
            height: heightBig,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: const Color.fromARGB(62, 255, 255, 255)),
                //child: Image.asset("assets/$cardNumber4.png"),
              child:(basra[3] && widget.playerNumber == myNumber)? SizedBox(height: heightBig,width: widtth,) : InkWell(onTap: ()=>_isLoading9_10? null : onPressCard(3),enableFeedback: false,child: Image(image: ResizeImage(AssetImage('assets/${flag[3]? "back" : widget.fourCards[3]}.png'), width: widtth.round(), height: heightBig.round()))),
          ),
        ),
      ],
    );
  }
}
