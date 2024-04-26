import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screw/main.dart';
import 'package:screw/provider/player.dart';
import 'package:screw/screens/main_screen.dart';

class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({super.key});
  int _getNumberOfPlayers(List docsData)
  {   
    for(int i=0;i<docsData.length;i++)
    {
      if(docsData[i].id == 'middleCards')
      {
        return docsData[i].data()['numberOfPlayers'];
      }
    }
    return 0;
  }
  List _getNames(List docsData,ref)
  {
    List names = [];
    final myName = ref.read(playerProvider.notifier).getName();
    for(int i=0;i<docsData.length;i++)
    {
      if(docsData[i].id.contains('player'))
      {
        final name = docsData[i].data()['name'];
        if(name != myName)
        {
          names.add(name);
        }
      }
    }
    return names;
  }
  @override
  Widget build(BuildContext context,ref) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(kCode)
            .snapshots(),
        builder: (ctx, snapshot) {
          if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting || snapshot.hasError)
          {
            return const Center(child: CircularProgressIndicator(),);
          }
          final playersInLobby =  snapshot.data!.size - 2;
          final numberOfplayers = _getNumberOfPlayers(snapshot.data!.docs);
          if (playersInLobby !=numberOfplayers)
          {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(kCode),
                const SizedBox(height: 30,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$playersInLobby /$numberOfplayers'),const SizedBox(width: 35,),const CircularProgressIndicator()
                  ],
                )
              ],
            );
          }
          else
          {
            final names = _getNames(snapshot.data!.docs, ref);
            return MainScreen(playerNames: names,);
          }

  }
    );
}
}