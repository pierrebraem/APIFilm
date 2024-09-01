import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'classes/media.dart';
import 'pages/recherche.dart';
import 'pages/enregistrer.dart';
import '../fonctions.dart' as fonctions;
import 'styles.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build (BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        extensions: <ThemeExtension<dynamic>>[
          const ClassicText(color: Colors.green),
          MediaTitle(color: Colors.green, size: Theme.of(context).textTheme.displaySmall),
          SearchTitle(color: Colors.green, size: Theme.of(context).textTheme.titleLarge, fontWeight: FontWeight.bold)
        ]
      ),
      title: 'Braemmedia',
      home: const Execution(),
    );
  }
}

class Execution extends StatefulWidget{
  const Execution({Key? key}) : super(key: key);

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Execution>{
  final controller = TextEditingController();
  late Future<List<Media>> listeFilm;
  String dropdownValue = 'movie';

  List jsonTranslate = [];
  Future<void> loadText() async {
    final String jsonString = await rootBundle.loadString(await fonctions.loadTanslate());
    final json = await jsonDecode(jsonString);
    setState(() {
      jsonTranslate = json['translate'];
    });
  }

  @override
  void initState(){
    super.initState();
    loadText();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("BraemMedia"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: jsonTranslate.isNotEmpty?Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: jsonTranslate[0]['searchInputLabel'],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
          DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
            items: [
              DropdownMenuItem<String>(
                value: 'movie',
                child: Text(jsonTranslate[0]['dropDownSearchMovie'])
              ),
              DropdownMenuItem<String>(
                value: 'series',
                child: Text(jsonTranslate[0]['dropDownSearchSeries'])
              ),
              DropdownMenuItem<String>(
                value: 'game',
                child: Text(jsonTranslate[0]['dropDownSearchGames']),
              ),
              DropdownMenuItem<String>(
                value: 'all',
                child: Text(jsonTranslate[0]['dropDownSearchAll'])
              )
            ]
          ),
          ElevatedButton(
            onPressed: () {
              if(controller.text.length < 3){
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(jsonTranslate[0]['showDialogErrorTitle']),
                    content: Text(jsonTranslate[0]['showDialogErrorContent']),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                );
              }
              else{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Recherche(text: controller.text, dropdownValue: dropdownValue, jsonTranslate: jsonTranslate)),
                );
              }
            },
            child: Text(jsonTranslate[0]['SearchLabel']),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Enregistrer())
              );
            }, 
            child: const Text('Consulter les médias enregistrés')
          ),
          /* BOUTON POUR LES TESTS. SUPPRIMER LE BOUTON AVANT LA SORTIE DE LA 1.2 */
          ElevatedButton(
            onPressed: () async {
              await fonctions.deleteFile();
            }, 
            child: const Text('Supprimer fichier')
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: const Text('Version 1.2-dev')
            ) 
          )
        ],
      ): const Text("Loading json file..."),
    );
  }
}