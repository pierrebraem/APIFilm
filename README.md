# Présentation du projet
BraemMedia est une application réalisée en Flutter. Elle permet de récupérer des informations sur un film, une série ou un jeu en utilisant [OMDb API](https://www.omdbapi.com/).

# Comment utiliser l'application
L'application est simple d'utilisation. La première page vous invite à saisir le titre et le type du média. Après avoir cliqué sur le bouton "Rechercher", une liste de contenu devrait s'afficher. Cliquez sur l'un des médias proposés pour obtenir des informations sur celui-ci (date de sortie, description, auteurs, note métacritic, etc.), ainsi qu'une liste de saisons et d'épisodes si le média est une série.

# Vidéo de présentation du projet
[Vidéo de présentation du projet sur Youtube](https://www.youtube.com/watch?v=_pXkhk5wHVQ&ab_channel=Cumulo)

# Vous voulez tester l'application ?
Vous pouvez l'installer et le tester sur un appareil Android en téléchargeant les fichiers .apk situés dans les [releases de GitHub](https://github.com/pierrebraem/APIFilm/releases).
L'application n'est pas disponible pour les appareils iOS.

# Entrez une clé API
Afin de pouvoir utiliser l'application, une clé d'API est requise pour interagir avec cette dernière.
Dans un premier temps, vous devez créer un fichier `api.dart` dans le dossier `lib` du projet.
Dans ce fichier, entrez la ligne de code suivante :
```
const String key = <Clé>;
```
# Générer un .apk
Pour générer un .apk, vous devez ouvrir un terminal à la racine du projet et taper la commande `flutter build apk --build-name=<Version>`
Le fichier .apk doit se trouver dans `build\app\outputs\flutter-apk\app-release.apk`
