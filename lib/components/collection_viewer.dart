import 'package:flutter/material.dart';

import '/screens/search_screen.dart';

class CollectionViewer extends StatelessWidget {
  final String? title;
  final String? description;
  final String? imageLink;
  const CollectionViewer({Key? key, this.title, this.imageLink, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: Text(
              title!.toUpperCase(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          MaterialButton(
            minWidth: double.infinity,
//              height: SizeConfig.blockSizeVertical * 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchScreen(title!),
                ),
              );
            },
            child: Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  imageLink!,
//                  width: SizeConfig.blockSizeHorizontal * 80,
//                  fit: BoxFit.cover,
//                  height: SizeConfig.blockSizeVertical * 30,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: Text(
              description!,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          )
        ],
      ),
    );
  }
}
