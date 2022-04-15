import '/screens/search_screen.dart';
import '/utilities/constants.dart';
import 'package:flutter/material.dart';

class CollectionRenderer extends StatelessWidget {
  final List _collectionList = kCollectionList;
  final bool? isScrollable;
  const CollectionRenderer({Key? key, this.isScrollable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isScrollable!
        ? ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                elevation: 7.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8.0),
                      child: Text(
                        _collectionList[index]['name'].toString().toUpperCase(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    MaterialButton(
//              height: SizeConfig.blockSizeVertical * 30,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SearchScreen(_collectionList[index]['name']),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          _collectionList[index]['image'],
//                          width: SizeConfig.screenWidth,
//                          height: SizeConfig.blockSizeVertical * 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8.0),
                      child: Text(
                        _collectionList[index]['description'],
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: _collectionList.length,
          )
        : Column(
            children: _collectionList.map(
              (colt) {
                return Card(
                  elevation: 7.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        child: Text(
                          colt['name'].toString().toUpperCase(),
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
                              builder: (BuildContext context) =>
                                  SearchScreen(colt['name']),
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(
                              colt['image'],
//                              width: SizeConfig.blockSizeHorizontal * 80,
//                              fit: BoxFit.cover,
//                              height: SizeConfig.blockSizeVertical * 30,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        child: Text(
                          colt['description'],
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    ],
                  ),
                );
              },
            ).toList(),
          );
  }
}
