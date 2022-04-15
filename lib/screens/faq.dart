import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
// ----------------------------------ADD ALL THE QUESTIONS AND ANSWERS BELOW IN THE item LIST--------------------------------------
  final List<Item> item1 = [
    Item(
        question: 'This will be a question?',
        answer: 'This will be the answer ;-) !!!'),
//    Item(question: 'This is question 2?', answer: 'This is your answer!!!'),
//    Item(question: 'This is question 3?', answer: 'This is your answer!!!'),
//    Item(question: 'This is question 4?', answer: 'This is your answer!!!'),
  ];
  @override
  Widget build(BuildContext context) {
    TextStyle textStyleGroup = TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.bold,
        fontSize: 20.0);
    TextStyle textStyleQuestion = const TextStyle(color: Colors.black);
    TextStyle textStyleAnswer =
        const TextStyle(color: Colors.black26, fontSize: 16.0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'FAQs',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 20.0,
              ),
//            ExpansionPanelList(
//              expansionCallback: (int index, bool isExpanded) {
//                setState(() {
//                  item1[index].isExpanded = !isExpanded;
//                });
//              },
//              children: item1.map<ExpansionPanel>((Item item) {
//                return ExpansionPanel(
//                  canTapOnHeader: true,
//                  headerBuilder: (BuildContext context, bool isExpanded) {
//                    return ListTile(
////                        trailing: Icon(Icons.expand_more),
//                        title: Text(
//                      item.question,
//                      textAlign: TextAlign.left,
//                      style: textStyleQuestion,
//                    ));
//                  },
//                  isExpanded: item.isExpanded,
//                  body: Text(
//                    item.answer,
//                    style: textStyleAnswer,
//                    textAlign: TextAlign.left,
//                  ),
//                );
//              }).toList(),
//            ),
//            SizedBox(
//              height: 10.0,
//            ),
              Text(
                'FAQ Coming Up',
                style: textStyleGroup,
                textAlign: TextAlign.left,
              ),
              for (var item in item1)
                ExpansionTile(
                  onExpansionChanged: (isExpanded) =>
                      setState(() => item.isExpanded = isExpanded),
                  expandedAlignment: Alignment.topLeft,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  trailing: item.isExpanded
                      ? const Icon(
                          Icons.expand_less,
                        )
                      : const Icon(Icons.expand_more),
                  title: Text(
                    item.question!,
                    style: textStyleQuestion,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        item.answer!,
                        style: textStyleAnswer,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    this.answer,
    this.question,
    this.isExpanded = false,
  });

  String? answer;
  String? question;
  bool isExpanded;
}
