import '/components/drill_list_renderer.dart';
import '/objects/favorites.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final drillList = Provider.of<Favorites>(context);
    return Scaffold(
      body: Container(
//   TODO penser à éventuellement ajouter un filtre sur les favoris, mais ce n'est pas une priorité
        child: DrillListRenderer(drillList.getFavoriteDrills(context)),
      ),
    );
  }
}
