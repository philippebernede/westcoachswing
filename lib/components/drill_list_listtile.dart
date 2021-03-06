import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/workouts.dart';
import '/objects/drill.dart';

import '/objects/favorites.dart';
import '/screens/drill_presentation_screen.dart';
import '/utilities/size_config.dart';

class DrillListTile extends StatelessWidget {
  final Drill? drill;
  const DrillListTile({Key? key, this.drill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late double _rating;
    final favorite = Provider.of<Favorites>(context);
    final workout = Provider.of<Workouts>(context);
    final snackBarAdd = SnackBar(
      duration: const Duration(seconds: 2),
      content: Text('${drill!.name} has been added to your favorites'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          favorite.removeFavorite(drill!.id!, context);
        },
      ),
    );
    final snackBarRemove = SnackBar(
      duration: const Duration(seconds: 2),
      content: Text('${drill!.name} has been removed from your favorites'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          favorite.addFavorite(drill!.id!, context);
        },
      ),
    );

    return Card(
      elevation: 7.0,
      child: ListTile(
        leading: SizedBox(
            width: SizeConfig.screenWidth! * 0.2,
            child: Image.asset(
              drill!.imageLink!,
              errorBuilder: (context, url, error) => const Icon(Icons.error),
            )
            // CachedNetworkImage(
            //   imageUrl: drill!.imageLink!,
            //   placeholder: (context, url) =>
            //       const Center(child: CircularProgressIndicator()),
            //   errorWidget: (context, url, error) => const Icon(Icons.error),
            // ),
            ),
//        Image.network(drill.imageLink),
        title: Text(drill!.name!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Level : '),
                RatingBar.builder(
                  tapOnlyMode: false,
                  itemCount: 5,
                  ignoreGestures: true,
                  initialRating: drill!.level!.index.toDouble() + 1,
                  direction: Axis.horizontal,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemSize: 20.0,
                  unratedColor: Colors.teal.withOpacity(0.2),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.teal,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ],
            ),
            Text(
//            '${drill.level.toString()} and duration = ${drill.duration.toString().substring(0, 2)} min ${drill.duration.toString().substring(3, 5) == '00' ? '' : drill.duration.toString().substring(3, 5)} sec'),
                'Practice Time  : ${drill!.duration.toString()} min'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            favorite.isFavorite(drill!.id!)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            if (favorite.isFavorite(drill!.id!)) {
              favorite.removeFavorite(drill!.id!, context);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(snackBarRemove);
            } else {
              favorite.addFavorite(drill!.id!, context);
//    permet de supprimer la snackbar qui ??tait encore pr??sente sur l'??cran au moment  d'appuyer sur un autre bouton
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(snackBarAdd);
            }

            // Find the Scaffold in the widget tree and use
            // it to show a SnackBar.

//            TODO ajouter la fonction pour ajouter le drill s??lectionn?? ?? la liste des drills s??lectionn??s
//            setState(() {
//              isSelected ? isSelected = false : isSelected = true;
//            });
          },
        ),
        onTap: () {
//          drillList.setSelectedDrillById = drill.id;
//   si on s??lectionne un drill dans la recherche ??a veut dire que l'on est en entra??nement unique et donc ??a serait un workout de type 0
//   ce que l'on s??lectionne maintenant
          workout.selectedWorkout(0, context, drill!.id!);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  DrillPresentationScreen(drill!.id!),
            ),
          );
        },
      ),
    );
  }
}
