import 'package:braemmedia/styles.dart';
import 'package:flutter/material.dart';
import '../classes/media.dart';
import 'detail.dart';
import '../fonctions.dart' as fonctions;

class Recherche extends StatelessWidget{
  Recherche({super.key, required this.text, required this.dropdownValue, required this.jsonTranslate});

  final dynamic text;
  final dynamic dropdownValue;
  final List jsonTranslate;
  late final Future<List<Media>> listeFilm = fonctions.recupMedia(text, dropdownValue);

  @override
  Widget build(BuildContext context){
    final SearchTitle searchTitle = Theme.of(context).extension<SearchTitle>()!;

    return Scaffold(
        appBar: AppBar(
          title: Text(jsonTranslate[0]['SearchLabel']),
        ),
        body: Center(
            child: FutureBuilder(
                future: listeFilm,
                builder: (context, AsyncSnapshot snapshot){
                  if(snapshot.hasData) {
                    if(snapshot.data.isEmpty){
                      return Text(jsonTranslate[0]['searchPageNoResult']);
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const Divider(color: Colors.cyan),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(
                              '${(snapshot.data as dynamic)[index].title}',
                              textAlign: TextAlign.center,
                              style: searchTitle.size!.copyWith(color: searchTitle.color, fontWeight: searchTitle.fontWeight)
                            ),
                            subtitle: Text(
                              '${(snapshot.data as dynamic)[index].annee}',
                              textAlign: TextAlign.center,
                            ),
                            leading: Image.network(
                              (snapshot.data as dynamic)[index].urlImage,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/non_images.png');
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (
                                    context) => Detail(imdbID: '${(snapshot.data as dynamic)[index].imdbID}', jsonTranslate: jsonTranslate,)
                                ),
                              );
                            }
                        );
                      },
                    );
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