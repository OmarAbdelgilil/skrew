import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screw/main.dart';
import 'package:screw/screens/start_screen.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});
  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  List<Map<String, dynamic>?>? allPlayerDataSorted;
  Widget? activeScreen;
  Future<void> _getAllPlayersData() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection(kCode).get();
    final allData = querySnapshot.docs.map((doc) {
      if (doc.id.contains('player'))
      {
        return doc.data();
      }
    }).toList();
    allData.removeWhere((value) => value == null);
    if (allData.length > 1)
    {
      allData.sort((a, b) => (b!['score']).compareTo(a!['score']));
      setState(() {
        allPlayerDataSorted = allData.reversed.toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllPlayersData();
  }
  void _leaveGame()
  {
    //delete the collection
    setState(() 
    {
      activeScreen = const StartScreen();
    });
  }
  @override
  Widget build(BuildContext context) {
    if(allPlayerDataSorted == null )
    {
      return const Center(child: CircularProgressIndicator(),);
    }
    return activeScreen?? Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed:_leaveGame, icon: const Icon(Icons.exit_to_app))
      ]),
      body: ListView.builder(itemCount: allPlayerDataSorted!.length,itemBuilder: (context, index) => Center(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${(index+1).toString()}) ${allPlayerDataSorted![index]!["name"]} score =  ${allPlayerDataSorted![index]!["score"]}',),
          const SizedBox(width: 25,)
        ],
      ))
    ),);
  }
}
