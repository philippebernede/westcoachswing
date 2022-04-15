import '/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Phil and Flore'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/whiteBrick.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: SizeConfig.blockSizeHorizontal! * 25,
                    backgroundImage: const AssetImage(
                      'assets/PhilandFlore.jpg',
                    ),
                  ),
                ),
              ),
//            Center(
//              child: Image.asset(
//                'assets/PhilandFlore.jpg',
//              ),
//            ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text:
                            'Philippe and Flore Berne are two professional dancers, choreographers, teachers and judges from Canada. They are among the best dancers in the world in West Coast Swing.'
                            ' \n\nTheir ',
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const TextSpan(
                        text: 'Leitmotiv',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          height: 1.2,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ' is : "Everyone can find their story in west coast swing. It connects '
                            'with human experience. We express who we are and'
                            'connect with others."'
                            '\n\nIf You want to know more about Philippe and Flore go check their website ',
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'philandflore.com',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          height: 1.2,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch('http://www.philandflore.com');
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
