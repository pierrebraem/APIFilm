import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("BraemMedia"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Entrer le nom d\'un média',
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
            items: const [
              DropdownMenuItem<String>(
                value: 'movie',
                child: Text('Film')
              ),
              DropdownMenuItem<String>(
                value: 'series',
                child: Text('Série')
              ),
              DropdownMenuItem<String>(
                value: 'game',
                child: Text('Jeux'),
              ),
              DropdownMenuItem<String>(
                value: 'all',
                child: Text('Tout')
              )
            ]
          ),
          ElevatedButton(
            onPressed: () {
              if(controller.text.length < 3){
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Erreur de saisie'),
                    content: const Text('Votre saisie doit comporter 3 caractères ou plus'),
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
                  MaterialPageRoute(builder: (context) => Recherche(text: controller.text, dropdownValue: dropdownValue)),
                );
              }
            },
            child: const Text('Rechercher'),
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
      ),
    );
  }
}