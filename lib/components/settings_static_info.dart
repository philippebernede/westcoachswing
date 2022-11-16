import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/screens/about_us.dart';
import '/screens/faq.dart';
import '/screens/privacy_policy.dart';
import '/screens/terms_and_conditions.dart';
import '/utilities/constants.dart';
import '/components/settings_button.dart';
import '/components/delete_account.dart';

class SettingsStaticInfo extends StatelessWidget {
  const SettingsStaticInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SettingsButton('About Phil and Flore', () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AboutUs()));
        }),
        SettingsButton('Frequently Asked Questions (FAQ)', () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FAQ()));
        }),
        SettingsButton('About this version', () {
          showAboutDialog(
            context: context,
            applicationIcon: kLogoNoir,
            applicationVersion: 'Béta Version 0.1.21 October 2020',
            applicationName: 'West Coach Swing',
            applicationLegalese:
                'This version is the first beta version of the WestCoachSwing app. We hope you will like it. \nFor any suggestions please contact us at westcoachswing@gmail.com',
          );
        }),
        SettingsButton('Contact us | Support', () {
          launch('mailto:westcoachswing@gmail.com');
        }),
        SettingsButton('Terms & Conditions', () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TermsAndConditions()));
        }),
        SettingsButton('Privacy Policy', () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PrivacyPolicy()));
        }),
//TODO: Add the delete account option back
        // SettingsButton('Delete Account', () {
        //   showDialog(context: context, builder: (_) => const DeleteAccount());
        // }),
//---------------------------------------------------------------------OLD BUTTONS LIST--------------------------------------------------------------------
//          RaisedButton(
//            elevation: 2.0,
//            onPressed: () {
//              Navigator.push(
//                  context, MaterialPageRoute(builder: (context) => AboutUs()));
//            },
//            child: Align(
//                alignment: Alignment.centerLeft,
//                child: Text('About Phil and Flore')),
//          ),
//          RaisedButton(
//            elevation: 2.0,
//            onPressed: () {
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => PrivacyPolicy()));
//            },
//            child: Align(
//              alignment: Alignment.centerLeft,
//              child: Text(
//                'Privacy Policy',
//              ),
//            ),
//          ),
//          RaisedButton(
//            elevation: 2.0,
//            onPressed: () {
//              Navigator.push(
//                  context, MaterialPageRoute(builder: (context) => FAQ()));
//            },
//            child: Align(
//              alignment: Alignment.centerLeft,
//              child: Text(
//                'Frequently Asked Questions (FAQ)',
//              ),
//            ),
//          ),
//          RaisedButton(
//            elevation: 2.0,
//            onPressed: () {
//              showAboutDialog(
//                context: context,
//                applicationIcon: kLogoNoir,
//                applicationVersion: 'Béta Version 0.1 October 2020',
//                applicationName: 'West Coach Swing',
//                applicationLegalese:
//                    'This version is the first beta version of the WestCoachSwing app. We hope you will like it. \nFor any suggestions please contact us at westcoachswing@gmail.com',
//              );
//            },
//            child: Align(
//              alignment: Alignment.centerLeft,
//              child: Text(
//                'About this version',
//              ),
//            ),
//          ),
//          RaisedButton(
//            elevation: 2.0,
//            onPressed: () {
//              launch('mailto:westcoachswing@gmail.com');
//            },
//            child: Align(
//              alignment: Alignment.centerLeft,
//              child: Text(
//                'Contact us | Support',
//              ),
//            ),
//          ),
//          RaisedButton(
//            elevation: 2.0,
//            onPressed: () {
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => TermsAndConditions()));
//            },
//            child: Align(
//              alignment: Alignment.centerLeft,
//              child: Text(
//                'Terms & Conditions',
//              ),
//            ),
//          ),
////TODO:-----------------------------------------BOUTON DE SUPPRESSION DE COMPTE A AJOUTER DES QUE J'AI SOLUTIONNE LE PROBLÈME--------------------------------------------------------
//          RaisedButton(
//            elevation: 2.0,
//            onPressed: () {
//              showDialog(context: context, builder: (_) => DeleteAccount());
//            },
//            child: Align(
//              alignment: Alignment.centerLeft,
//              child: Text(
//                'Delete Account',
//              ),
//            ),
//          ),
      ],
    );
  }
}
