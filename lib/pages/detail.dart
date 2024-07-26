import 'package:flutter/material.dart';
import '../classes/detail_media.dart';
import '../classes/episode.dart';
import '../fonctions.dart' as fonctions;
import '../styles.dart';

class Detail extends StatelessWidget{
  Detail({super.key, required this.imdbID});

  final dynamic imdbID;
  late final Future<DetailMedia> filmDetail = fonctions.recupDetailMedia(imdbID);

  @override
  Widget build(BuildContext context){
    final ClassicText classicText = Theme.of(context).extension<ClassicText>()!;
    final MediaTitle mediaTitle = Theme.of(context).extension<MediaTitle>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Center(
        child: FutureBuilder(
          future: filmDetail,
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              return ListView(
                children: <Widget>[
                  Container(
                    padding: (
                        const EdgeInsets.only(left: 20, top: 20)
                    ),
                  ),
                  Text("${(snapshot.data).title}", textAlign: TextAlign.center, style: mediaTitle.size!.copyWith(color: mediaTitle.color)),
                  Text("${(snapshot.data).released}", textAlign: TextAlign.center, style: TextStyle(color: classicText.color)),
                  Text("${(snapshot.data).genre}", textAlign: TextAlign.center, style: TextStyle(color: classicText.color)),
                  Image.network("${(snapshot.data).urlImage}", width: 300, height: 300, errorBuilder: (context, error, stackTrace) {return Image.asset('assets/images/non_images.png');}),
                  IconButton(onPressed: () async {
                      await fonctions.writeMedia(imdbID, (snapshot.data).title, (snapshot.data).released, (snapshot.data).type);
                  }, 
                  icon: const Icon(Icons.playlist_add)),
                  Text("Type de média : ${(snapshot.data).type}", textAlign: TextAlign.center, style: TextStyle(color: classicText.color)),
                  Text("${(snapshot.data).plot}", textAlign: TextAlign.center, style: TextStyle(color: classicText.color)),
                  Text("Notation : ${(snapshot.data).rated}", textAlign: TextAlign.center, style: TextStyle(color: classicText.color)),
                  Text("Durée : ${(snapshot.data).runtime}", textAlign: TextAlign.center, style: TextStyle(color: classicText.color)),
                  Text("Directeur : ${(snapshot.data).director}", textAlign: TextAlign.center, style: TextStyle(color: classicText.color)),
                  Text("Écriture : ${(snapshot.data).writer}", textAlign: TextAlign.center, style: TextStyle(color: classicText.color)),
                  Text("Acteurs : ${(snapshot.data).actors}", textAlign: TextAlign.center, style: TextStyle(color: classicText.color)),
                  Text("Note métacritic sur 100 : ${(snapshot.data).metascore}", textAlign: TextAlign.center, style: TextStyle(color: classicText.color)),
                  (snapshot.data).dvd != null && (snapshot.data).type != 'game' ? Text("DVD : " "${(snapshot.data).dvd}", textAlign: TextAlign.center, style: TextStyle(color: classicText.color)) : const Text(""),


                  (snapshot.data).type == 'series' && (snapshot.data).episodes != null ?
                    Column(
                      children: [
                        for (int i = 0; i<(snapshot.data).episodes.length; i++)
                        Column(
                          children: [
                            Text("Saison ${i + 1}", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.green)),
                            for (Episode j in (snapshot.data).episodes[i])
                            ListTile(
                              title: Text(j.title),
                              subtitle: Text("Episode : ${j.episode} - Sorti le ${j.released}"),
                            )
                          ],
                        )
                      ],
                    )
                  : const Text("")
                ]
              );
            }
            else if(snapshot.hasError){
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }
        )
      ),
    );
  }
}