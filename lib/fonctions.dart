import 'dart:io';

import 'package:flutter/services.dart';

import 'classes/detail_media.dart';
import 'classes/media.dart';
import 'classes/episode.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'api.dart' as api;
import 'dart:convert';
import 'dart:developer';

const String apikey = api.key;

/* Fonctions pour manipuler les données OMDb API*/
Future<DetailMedia> recupDetailMedia(imdbID) async{
  final response = await http.get(Uri.parse("https://www.omdbapi.com/?i=$imdbID&apikey=$apikey"));

  if(response.statusCode == 200){
    final liste = json.decode("[${response.body}]") as List;
    DetailMedia detail = DetailMedia.fromJson(liste[0]);
    
    String? totalSeason = detail.totalSeason;
    if(detail.type == 'series' && totalSeason != null && totalSeason != "N/A"){
      final listeEpisodes = await recupEpisodes(imdbID, int.parse(totalSeason));
      detail.episodes = listeEpisodes;
    }

    return detail;
  }
  else{
    throw Exception("Erreur lors de l'appel de l'API");
  }
}

Future<List<Media>> recupMedia(recherche, type) async{
  String url = "";
  if(type == 'all'){
    url = "https://www.omdbapi.com/?s=$recherche&apikey=$apikey";
  }
  else{
    url = "https://www.omdbapi.com/?s=$recherche&type=$type&apikey=$apikey";
  }
  final response = await http.get(Uri.parse(url));

  if(response.statusCode == 200){
    if(json.decode(response.body)['Search'] != null){
      final liste = json.decode(response.body)['Search'] as List;
      return liste.map((data) => Media.fromJson(data)).toList();
    }
    return [];
  }
  else{
    throw Exception("Erreur lors de l'appel de l'API");
  }
}

Future<List<List<Episode>>> recupEpisodes(imdbID, totalSaison) async{
    List<List<Episode>> listeSaison = [];

    for(int i = 1; i <= totalSaison; i++){
      var response = await http.get(Uri.parse("https://www.omdbapi.com/?i=$imdbID&season=$i&apikey=$apikey"));
      if(response.statusCode == 200){
        if(json.decode(response.body)['Episodes'] != null){
          List<Episode> listeEpisode = [];
          var saison = json.decode(response.body)['Episodes'] as List;
          saison.map((data) => listeEpisode.add(Episode.fromJson(data))).toList();
          listeSaison.add(listeEpisode);
        }
      }
      else{
        throw Exception("Erreur lors de l'appel de l'API");
      }
    }

  return listeSaison;
}

/* Fonctions pour manipuler le fichier de sauvegarde */
Future<File> get _localFile async {
  final directory = await getApplicationDocumentsDirectory();

  final path = directory.path;

  return File('$path/media_saved.txt');
}

Future<File> writeMedia(imdbID, title, released, type) async {
  final file = await _localFile;

  return file.writeAsString('$imdbID, $title, $released, $type \n', mode: FileMode.append);
}

/* FONCTION TEMPORAIRE POUR LES TESTS. LA SUPPRIMER AVANT LA SORTIE DE LA 1.2 */
Future<int> deleteFile() async {
  final file = await _localFile;

  await file.delete();

  return 0;
}

Future<String> getAllSavedMedia() async {
  final file = await _localFile;

  final contents = await file.readAsString();

  return contents;
}

/* Fonction qui permet de charger un fichier de traduction en fonction de la langue du système */
Future<String> loadTanslate() async {
  final String langue = Platform.localeName;

  if(langue.startsWith('fr_')){
    return 'assets/traductions/traduction_fr.json';

  }
  
  return 'assets/traductions/traduction_en.json';
}