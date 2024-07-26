import 'package:flutter/material.dart';
import '../fonctions.dart' as fonctions;

class Enregistrer extends StatelessWidget{
  Enregistrer({super.key});

  late final Future<String> directory = fonctions.getAllSavedMedia();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Médias enregistrés')
      ),
      body: Center(
        child: FutureBuilder(
          future: directory,
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              return Text(snapshot.data);
            }
            else if(snapshot.hasError){
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }
        )
      )
    );
  }
}